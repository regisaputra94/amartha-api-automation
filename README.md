## ⚙️ Setup
### 1️⃣ Install Dependencies

Pastikan sudah terinstall:
- Python 3

Lalu install library Python:
```bash
pip install -r requirements.txt
```

## 🚀 Menjalankan Test

Jalankan semua test:
```bash
robot -d Reports Tests/
```

Atau test tertentu:
```bash
robot -d Reports tests/PetAPI.robot
```

## 📂 Struktur Folder
```bash
amartha-api-automation/
├── Libraries/                 # Berisi file-file config
├── Services/                  # Services Object Model
├── Tests/                     # Test cases
├── Reports/                   # Report hasil test di ignore di git
└── requirements.txt
```

Test Cases
1. Automate add new pet test case. Create 1 pet with name is "Cat1" and verify that pet has been created.
2. Automate add new pet test case. Create 1 pet with name is "Cat2" and verify that pet has been created.
3. Automate find pet by status test case. Get pets with status is "available" and verify that response only show pets with correct status.
4. Automate find pet by status test case. Get pets with status is "pending" and verify that response only show pets with correct status.
5. Automate find pet by id test case. Get pet with id is 2 (or other that give http 200 response) and verify that the response is in comply with the contract.

Once the automation deliverable is ready:
- Create a zip file of:
1. automation code with ReadMe file with steps to execute, command line to execute, and any dependencies needed to execute
2. test results for run from your local (can create a video recording) / can share a google drive link as well.
3. Send it to the recruiter via email also please mention what automation tools and programming language did you use.
This assignment is designed is to gauge your skills and give us an idea of how you approach tasks relevant to the QA Engineer role. The due date to submit the assignment in maximum 3 days.
