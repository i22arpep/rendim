#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define EXPORT __attribute__((visibility("default"))) __attribute__((used))

EXPORT void matrix_multiplication_ijk_o0(float* A, float* B, float* C, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            float sum = C[i * n + j];
            for (int k = 0; k < n; k++) {
                sum += A[i * n + k] * B[k * n + j];
            }
            C[i * n + j] = sum;
        }
    }
}

EXPORT void matrix_multiplication_ikj_o0(float* A, float* B, float* C, int n) {
    for (int i = 0; i < n; i++) {
        for (int k = 0; k < n; k++) {
            float a_ik = A[i * n + k];
            for (int j = 0; j < n; j++) {
                C[i * n + j] += a_ik * B[k * n + j];
            }
        }
    }
}

EXPORT void matrix_multiplication_jik_o0(float* A, float* B, float* C, int n) {
    for (int j = 0; j < n; j++) {
        for (int i = 0; i < n; i++) {
            float sum = C[i * n + j];
            for (int k = 0; k < n; k++) {
                sum += A[i * n + k] * B[k * n + j];
            }
            C[i * n + j] = sum;
        }
    }
}

EXPORT void matrix_multiplication_jki_o0(float* A, float* B, float* C, int n) {
    for (int j = 0; j < n; j++) {
        for (int k = 0; k < n; k++) {
            float b_kj = B[k * n + j];
            for (int i = 0; i < n; i++) {
                C[i * n + j] += A[i * n + k] * b_kj;
            }
        }
    }
}

EXPORT void matrix_multiplication_kij_o0(float* A, float* B, float* C, int n) {
    for (int k = 0; k < n; k++) {
        for (int i = 0; i < n; i++) {
            float a_ik = A[i * n + k];
            for (int j = 0; j < n; j++) {
                C[i * n + j] += a_ik * B[k * n + j];
            }
        }
    }
}

EXPORT void matrix_multiplication_kji_o0(float* A, float* B, float* C, int n) {
    for (int k = 0; k < n; k++) {
        for (int j = 0; j < n; j++) {
            float b_kj = B[k * n + j];
            for (int i = 0; i < n; i++) {
                C[i * n + j] += A[i * n + k] * b_kj;
            }
        }
    }
}
