#include <algorithm>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <vector>

#include <givaro/modular-balanced.h>
#include <fflas-ffpack/ffpack/ffpack.h>

template <class T>
void read_exact(std::ifstream& input, T* target, std::size_t count) {
    input.read(reinterpret_cast<char*>(target),
               static_cast<std::streamsize>(count * sizeof(T)));
    if (!input) throw std::runtime_error("short input");
}

// Independent verifier backend: unlike the producer's balanced-float helper,
// this uses the balanced-double FFLAS specialization and only returns rank.
int main(int argc, char** argv) {
    if (argc != 2) {
        std::cerr << "usage: verify_rank_u8_double MATRIX.bin\n";
        return 2;
    }
    std::ifstream input(argv[1], std::ios::binary);
    if (!input) throw std::runtime_error("cannot open input");
    std::uint64_t rows = 0, columns = 0, prime = 0;
    read_exact(input, &rows, 1);
    read_exact(input, &columns, 1);
    read_exact(input, &prime, 1);
    const std::size_t count = static_cast<std::size_t>(rows * columns);
    std::vector<double> matrix(count);
    constexpr std::size_t chunk_size = 1U << 22;
    std::vector<std::uint8_t> chunk(chunk_size);
    for (std::size_t offset = 0; offset < count;) {
        const std::size_t take = std::min(chunk_size, count - offset);
        read_exact(input, chunk.data(), take);
        for (std::size_t index = 0; index < take; ++index)
            matrix[offset + index] = static_cast<double>(chunk[index]);
        offset += take;
    }
    using Field = Givaro::ModularBalanced<double>;
    Field field(static_cast<double>(prime));
    const std::size_t rank = FFPACK::pRank(
        field, static_cast<std::size_t>(rows),
        static_cast<std::size_t>(columns), matrix.data(),
        static_cast<std::size_t>(columns));
    std::cout << "rows=" << rows << "\n"
              << "columns=" << columns << "\n"
              << "prime=" << prime << "\n"
              << "rank=" << rank << "\n";
    return 0;
}
