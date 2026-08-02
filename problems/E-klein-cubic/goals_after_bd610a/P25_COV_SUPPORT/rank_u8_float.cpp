#include <algorithm>
#include <cmath>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <string>
#include <vector>

#include <givaro/modular-balanced.h>
#include <fflas-ffpack/ffpack/ffpack.h>

namespace {

template <class T>
void read_exact(std::ifstream& input, T* target, std::size_t count) {
    input.read(reinterpret_cast<char*>(target),
               static_cast<std::streamsize>(count * sizeof(T)));
    if (!input) throw std::runtime_error("short input");
}

}  // namespace

// Exact rank (and optionally a right-kernel basis) of a dense uint8 matrix over
// a prime field.  The input format is
// three little-endian uint64 values (rows, columns, prime), followed by the
// row-major uint8 entries.  FFLAS-FFPACK performs the field arithmetic; float
// is only its exact modular storage type and cuts the replay footprint in half
// relative to the historical dense-double/FLINT calculation.
int main(int argc, char** argv) {
    if (argc != 2 && argc != 4) {
        std::cerr << "usage: rank_u8_float MATRIX.bin "
                     "[--right-kernel KERNEL.bin]\n";
        return 2;
    }
    const bool want_kernel = argc == 4 && std::string(argv[2]) == "--right-kernel";
    if (argc == 4 && !want_kernel) throw std::runtime_error("unknown option");
    std::ifstream input(argv[1], std::ios::binary);
    if (!input) throw std::runtime_error("cannot open input");

    std::uint64_t rows = 0, columns = 0, prime = 0;
    read_exact(input, &rows, 1);
    read_exact(input, &columns, 1);
    read_exact(input, &prime, 1);
    if (rows == 0 || columns == 0 || prime < 2 || prime > 127)
        throw std::runtime_error("invalid matrix header");

    const std::size_t count = static_cast<std::size_t>(rows * columns);
    std::vector<float> matrix(count);
    constexpr std::size_t chunk_size = 1U << 22;
    std::vector<std::uint8_t> chunk(chunk_size);
    std::size_t offset = 0;
    while (offset < count) {
        const std::size_t take = std::min(chunk_size, count - offset);
        read_exact(input, chunk.data(), take);
        for (std::size_t index = 0; index < take; ++index)
            matrix[offset + index] = static_cast<float>(chunk[index]);
        offset += take;
    }

    using Field = Givaro::ModularBalanced<float>;
    Field field(static_cast<float>(prime));
    std::size_t rank = 0;
    std::size_t nullity = 0;
    if (want_kernel) {
        float* kernel = nullptr;
        std::size_t leading = 0;
        FFPACK::NullSpaceBasis(
            field, FFLAS::FflasRight, static_cast<std::size_t>(rows),
            static_cast<std::size_t>(columns), matrix.data(),
            static_cast<std::size_t>(columns), kernel, leading, nullity);
        rank = static_cast<std::size_t>(columns) - nullity;
        if (leading != nullity)
            throw std::runtime_error("unexpected right-kernel leading dimension");
        std::ofstream output(argv[3], std::ios::binary);
        if (!output) throw std::runtime_error("cannot open kernel output");
        const std::uint64_t kernel_rows = columns;
        const std::uint64_t kernel_columns = nullity;
        output.write(reinterpret_cast<const char*>(&kernel_rows), sizeof(kernel_rows));
        output.write(reinterpret_cast<const char*>(&kernel_columns), sizeof(kernel_columns));
        output.write(reinterpret_cast<const char*>(&prime), sizeof(prime));
        for (std::size_t index = 0; index < columns * nullity; ++index) {
            long long value = static_cast<long long>(std::llround(kernel[index]));
            value %= static_cast<long long>(prime);
            if (value < 0) value += static_cast<long long>(prime);
            const auto byte = static_cast<std::uint8_t>(value);
            output.write(reinterpret_cast<const char*>(&byte), sizeof(byte));
        }
        FFLAS::fflas_delete(kernel);
    } else {
        rank = FFPACK::pRank(
            field, static_cast<std::size_t>(rows),
            static_cast<std::size_t>(columns), matrix.data(),
            static_cast<std::size_t>(columns));
        nullity = static_cast<std::size_t>(columns) - rank;
    }
    std::cout << "rows=" << rows << "\n"
              << "columns=" << columns << "\n"
              << "prime=" << prime << "\n"
              << "rank=" << rank << "\n"
              << "nullity=" << nullity << "\n";
    return 0;
}
