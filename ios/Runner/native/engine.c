#include <stdint.h>
#include <mach/mach_time.h>
#include <stdlib.h>

/**
 * RendiM Engine
 * Adaptación de tus códigos matrices.c y matrices2.c
 */

// Usamos la API de Apple para máxima precisión
uint64_t get_ticks() {
    return mach_absolute_time();
}

/**
 * Versión de matrices.c (Algoritmo IJK)
 * n: tamaño de la matriz (ej. 2048)
 */
void matrix_multiplication_ijk(float* a, float* b, float* c, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            for (int k = 0; k < n; k++) {
                // c[i][j] = c[i][j] + a[i][k] * b[k][j]
                c[i * n + j] += a[i * n + k] * b[k * n + j];
            }
        }
    }
}

/**
 * Versión de matrices2.c (Algoritmo IKJ - Optimizado)
 * n: tamaño de la matriz (ej. 2048)
 */
void matrix_multiplication_ikj(float* a, float* b, float* c, int n) {
    // Es vital limpiar la matriz C antes de empezar en IKJ
    for (int x = 0; x < n * n; x++) c[x] = 0.0f;

    for (int i = 0; i < n; i++) {
        for (int k = 0; k < n; k++) {
            float r = a[i * n + k]; // Guardamos el valor en un registro
            for (int j = 0; j < n; j++) {
                // c[i][j] = c[i][j] + r * b[k][j]
                c[i * n + j] += r * b[k * n + j];
            }
        }
    }
}