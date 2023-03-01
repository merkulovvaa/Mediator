# Патерн посередник реалізовано на основі програми Лікарня. Класи Doctor, Nurse, Pharmacy - це окремі
# "галузі", які не взаємодують між собою, а HospitalMediator - посередник, через якого вони всі спілкуються.
# Кожен член має ініціалізуватись у посередника. Doctor: запитує для пацієнта ліки в аптеці; Nurse: слудкує,
# що пацієнт отримав приписані йому ліки; Pharmacy: виконує запит лікаря і надсилає ліки. Усі ці дії проходять
# через посередника.

class Doctor
  attr_reader :name, :specialty, :mediator

  def initialize(name, specialty, mediator)
    @name = name
    @specialty = specialty
    @mediator = mediator
    mediator.add_doctor(self)
  end

  def request_medication(patient, medication)
    mediator.request_medication(patient, self, medication)
  end

  def receive_medication(medication)
    puts "#{name} received #{medication} medication from the pharmacy."
  end
end

class Nurse
  attr_reader :name, :mediator

  def initialize(name, mediator)
    @name = name
    @mediator = mediator
    mediator.add_nurse(self)
  end

  def administer_medication(patient, medication)
    puts "#{name} administered #{medication} medication to #{patient}."
  end
end

class Pharmacy
  attr_reader :name, :mediator

  def initialize(name, mediator)
    @name = name
    @mediator = mediator
    mediator.add_pharmacy(self)
  end

  def fulfill_request(patient, doctor, medication)
    puts "#{name} fulfilled a medication request for #{patient} from #{doctor.name} for #{medication}."
    mediator.notify_doctor_of_fulfillment(doctor, medication)
  end
end

class HospitalMediator
  def initialize
    @doctors = []
    @nurses = []
    @pharmacies = []
  end

  def add_doctor(doctor)
    @doctors << doctor
  end

  def add_nurse(nurse)
    @nurses << nurse
  end

  def add_pharmacy(pharmacy)
    @pharmacies << pharmacy
  end

  def request_medication(patient, doctor, medication)
    puts "#{doctor.name} requested #{medication} medication for #{patient}."
    @pharmacies.sample.fulfill_request(patient, doctor, medication)
  end

  def notify_doctor_of_fulfillment(doctor, medication)
    doctor.receive_medication(medication)
  end
end

# Example
mediator = HospitalMediator.new

doctor1 = Doctor.new("Dr. Alexandrov", "Cardiology", mediator)
doctor2 = Doctor.new("Dr. Kolesnikov", "Oncology", mediator)

nurse1 = Nurse.new("Nurse Sotnikova", mediator)
nurse2 = Nurse.new("Nurse Merkulova", mediator)

pharmacy1 = Pharmacy.new("911", mediator)
pharmacy2 = Pharmacy.new("Pharm", mediator)

doctor1.request_medication("Vasil Vasilenko", "Korvalol")
doctor2.request_medication("Ivan Ivanov", "Morphine")

nurse1.administer_medication("Vasil Vasilenko", "Korvalol")
nurse2.administer_medication("Ivan Ivanov", "Morphine")
