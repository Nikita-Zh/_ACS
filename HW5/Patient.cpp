#include "Patient.h"
#include <utility>

Patient::Patient(std::string name) {
    //name_ = std::move(name);
    name_ = name;
}
