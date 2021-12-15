#include <iostream>
#include <utility>
#include <pthread.h>
#include <cstdlib>
#include <unistd.h>

#include "Patient.h"

using std::cout;
using std::cin;
using std::string;

pthread_mutex_t mutexDentist;
pthread_mutex_t mutexTherapist;
pthread_mutex_t mutexSurgeon;
pthread_mutex_t mutexRandom;

int getRandomNumber(int min, int max) {
    pthread_mutex_lock(&mutexRandom);
    int res = min + rand() % (max - min + 1);
    pthread_mutex_unlock(&mutexRandom);
    return res;
}

class Dentist {
private:
public:
    static void getPatient(const Patient &patient) {
        pthread_mutex_lock(&mutexDentist);
        cout << patient.name_ << " entered to Dentist, Hello!" << "\n";
        sleep(1);
        cout << patient.name_ << " Exit from Dentist, Chao!" << "\n";
        pthread_mutex_unlock(&mutexDentist);
    }
};

class Therapist {
private:
public:
    static void getPatient(const Patient &patient) {
        pthread_mutex_lock(&mutexTherapist);
        cout << patient.name_ << " entered to Therapist, Hi!" << "\n";
        sleep(1);
        cout << patient.name_ << " exit from Therapist, Bye!" << "\n";
        pthread_mutex_unlock(&mutexTherapist);
    }
};

class Surgeon {
private:
public:
    static void getPatient(const Patient &patient) {
        pthread_mutex_lock(&mutexSurgeon);
        cout << patient.name_ << " entered to Surgeon, Hi!" << "\n";
        sleep(2);
        cout << patient.name_ << " exit from Surgeon, Bye!" << "\n";
        pthread_mutex_unlock(&mutexSurgeon);
    }
};

static int iterator = 0;

void *run(void *param) {
    int a = *(int *) param;
    if (a == 0) {
        Dentist::getPatient(Patient("patient__" + std::to_string(iterator++)));
    } else if (a == 1) {
        Therapist::getPatient(Patient("patient__" + std::to_string(iterator++)));
    } else if (a == 2) {
        Surgeon::getPatient(Patient("patient__" + std::to_string(iterator++)));
    }
    return nullptr;
}

void *doctor_func(void *param) {
    int forWhatDoctor;
    int num_of_patients = *(int *) param;
    pthread_t patients[num_of_patients];
    for (int i = 0; i < num_of_patients; ++i) {
        forWhatDoctor = getRandomNumber(0, 2);
        pthread_create(&patients[i], nullptr, run, (void *) &forWhatDoctor);
    }
    for (int i = 0; i < num_of_patients; ++i) {
        pthread_join(patients[i], nullptr);
    }
    return nullptr;
}

int main() {
    pthread_t doctor_1;
    pthread_t doctor_2;
    int num_of_patients;
    int patients_for_first_doctor;
    int patients_for_second_doctor;


    cout << "Enter a num of patients [0;100]:\n";
    cin >> num_of_patients;
    if ((num_of_patients < 0) || (num_of_patients > 100)) {
        cout << "num of patients must be in range [0;100]\n";
        return 0;
    }

    patients_for_first_doctor = num_of_patients / 2;
    patients_for_second_doctor = num_of_patients - patients_for_first_doctor;

    pthread_mutex_init(&mutexDentist, nullptr);
    pthread_mutex_init(&mutexTherapist, nullptr);
    pthread_mutex_init(&mutexSurgeon, nullptr);
    pthread_mutex_init(&mutexRandom, nullptr);

    pthread_create(&doctor_1, nullptr, reinterpret_cast<void *(*)(void *)>(doctor_func),
                   (void *) &patients_for_first_doctor);
    pthread_create(&doctor_2, nullptr, reinterpret_cast<void *(*)(void *)>(doctor_func),
                   (void *) &patients_for_second_doctor);

    pthread_join(doctor_1, nullptr);
    pthread_join(doctor_2, nullptr);

    pthread_mutex_destroy(&mutexDentist);
    pthread_mutex_destroy(&mutexTherapist);
    pthread_mutex_destroy(&mutexSurgeon);
    pthread_mutex_destroy(&mutexRandom);

    return 0;
}