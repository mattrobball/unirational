#include <cstdint>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

#include <givaro/modular-balanced.h>
#include <fflas-ffpack/ffpack/ffpack.h>

template <class T>
void read_exact(std::ifstream& input, T* target, std::size_t count) {
    input.read(reinterpret_cast<char*>(target), static_cast<std::streamsize>(count * sizeof(T)));
    if (!input) throw std::runtime_error("short input");
}

int main(int argc, char** argv) {
    if (argc != 2 && argc != 3) {
        std::cerr << "usage: fflas_rank_u16 MATRIX.bin [--profile-only]\n";
        return 2;
    }
    const bool profile_only = argc == 3 && std::string(argv[2]) == "--profile-only";
    std::ifstream input(argv[1], std::ios::binary);
    if (!input) throw std::runtime_error("cannot open input");
    std::uint64_t rows, columns, prime, targets;
    read_exact(input, &rows, 1);
    read_exact(input, &columns, 1);
    read_exact(input, &prime, 1);
    std::vector<std::uint16_t> raw(static_cast<std::size_t>(rows * columns));
    read_exact(input, raw.data(), raw.size());
    read_exact(input, &targets, 1);
    std::vector<std::uint16_t> raw_targets(static_cast<std::size_t>(targets * columns));
    read_exact(input, raw_targets.data(), raw_targets.size());

    using Field = Givaro::ModularBalanced<double>;
    Field field(static_cast<double>(prime));
    auto rank_of = [&](std::uint64_t extra_begin, std::uint64_t extra_count) {
        const std::size_t total_rows = static_cast<std::size_t>(rows + extra_count);
        std::vector<double> matrix(total_rows * static_cast<std::size_t>(columns));
        for (std::size_t index = 0; index < raw.size(); ++index)
            matrix[index] = static_cast<double>(raw[index]);
        for (std::size_t row = 0; row < extra_count; ++row) {
            const std::size_t source = static_cast<std::size_t>((extra_begin + row) * columns);
            const std::size_t destination = static_cast<std::size_t>((rows + row) * columns);
            for (std::size_t column = 0; column < columns; ++column)
                matrix[destination + column] = static_cast<double>(raw_targets[source + column]);
        }
        return FFPACK::pRank(field, total_rows, static_cast<std::size_t>(columns),
                             matrix.data(), static_cast<std::size_t>(columns));
    };

    const auto base_rank = rank_of(0, 0);
    std::cout << "base_rank=" << base_rank << "\n";
    if (!profile_only) {
        const auto joint_rank = rank_of(0, targets);
        std::cout << "joint_rank=" << joint_rank << " targets=" << targets << "\n";
        for (std::uint64_t target = 0; target < targets; ++target) {
            const auto rank = rank_of(target, 1);
            std::cout << "target=" << target << " augmented_rank=" << rank
                      << " member=" << (rank == base_rank ? 1 : 0) << "\n";
        }
    }

    std::vector<double> profile_matrix(raw.size());
    for (std::size_t index = 0; index < raw.size(); ++index)
        profile_matrix[index] = static_cast<double>(raw[index]);
    std::size_t* profile = nullptr;
    const auto profile_rank = FFPACK::pRowRankProfile(
        field, static_cast<std::size_t>(rows), static_cast<std::size_t>(columns),
        profile_matrix.data(), static_cast<std::size_t>(columns), profile);
    if (profile_rank != base_rank) throw std::runtime_error("rank-profile mismatch");
    const std::string profile_path = std::string(argv[1]) + ".rows";
    std::ofstream profile_output(profile_path, std::ios::binary);
    const std::uint64_t profile_count = profile_rank;
    profile_output.write(reinterpret_cast<const char*>(&profile_count), sizeof(profile_count));
    for (std::size_t index = 0; index < profile_rank; ++index) {
        const std::uint64_t row = profile[index];
        profile_output.write(reinterpret_cast<const char*>(&row), sizeof(row));
    }
    delete[] profile;
    std::cout << "row_profile=" << profile_path << " count=" << profile_rank << "\n";
    return 0;
}
