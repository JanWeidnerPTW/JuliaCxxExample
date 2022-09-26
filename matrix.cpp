extern "C" {
    #include "matrix.h"
}
#include <iostream>
#include <memory>

class Matrix {
public:
    Matrix(int length_) {
        float* data = new float[length_];
        shared_data = std::shared_ptr<float>(data);
        length = length_;
    }

    void copyFromMatrix(float* out) {
        float* ptr = shared_data.get();
        for (int i=0; i<length; i++) {
            out[i] = ptr[i];
        }
    }
    void copyIntoMatrix(float* data) {
        float* ptr = shared_data.get();
        for (int i=0; i<length; i++) {
            ptr[i] = data[i];
        }
    }

    void print() {
        for (int i=0; i<length; i++) {
            std::cout << shared_data.get()[i] << std::endl;
        }
    }
    std::shared_ptr<float> shared_data;
    int length;
};

void* newMatrix(int length) {
    return new Matrix(length);
}

void deleteMatrix(void* matrix) {
    Matrix* m = (Matrix*)(matrix);
    delete m;
}

void printMatrix(void* matrix) {
    Matrix* m = (Matrix*)(matrix);
    m->print();
}

void copyIntoMatrix(void *matrix, float *data) {
    Matrix* m = (Matrix*)(matrix);
    m->copyIntoMatrix(data);
}

void copyFromMatrix(float *out, void* matrix) {
    Matrix* m = (Matrix*)(matrix);
    m->copyFromMatrix(out);
}
