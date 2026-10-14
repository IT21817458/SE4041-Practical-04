
import SwiftUI

struct Student: Identifiable {
    let id = UUID()
    var name: String
    var mark: Int

    var passed: Bool {
        mark >= 50
    }

    var grade: String {
        switch mark {
        case 80...100: return "A"
        case 75..<80: return "A-"
        case 70..<75: return "B+"
        case 65..<70: return "B"
        case 60..<65: return "B-"
        case 55..<60: return "C+"
        case 45..<55: return "C"
        case 40..<45: return "C-"
        default: return "F"
        }
    }
}

struct ContentView: View {
    @State private var students: [Student] = []
    @State private var studentName = ""
    @State private var markText = ""

    var passedCount: Int {
        students.filter { $0.passed }.count
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("Student Name", text: $studentName)
                    .textFieldStyle(.roundedBorder)

                TextField("Mark (0-100)", text: $markText)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)

                Button("Add Student") {
                    let cleanName = studentName.trimmingCharacters(in: .whitespaces)

                    guard !cleanName.isEmpty,
                          let mark = Int(markText),
                          (0...100).contains(mark) else {
                        return
                    }

                    students.append(Student(name: cleanName, mark: mark))
                    studentName = ""
                    markText = ""
                }
                .buttonStyle(.borderedProminent)

                Text("Passed Students: \(passedCount)")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                List(students) { student in
                    NavigationLink {
                        StudentDetailView(student: student)
                    } label: {
                        HStack {
                            Text(student.name)
                            Spacer()
                            Text("\(student.mark)")
                                .bold()
                                .foregroundStyle(student.passed ? .green : .red)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("SE4041 Marks")
        }
    }
}

struct StudentDetailView: View {
    let student: Student

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)

            Text(student.name)
                .font(.largeTitle)
                .bold()

            Text("Mark: \(student.mark)")
                .font(.title2)

            Text(student.passed ? "PASS" : "FAIL")
                .font(.title)
                .bold()
                .foregroundStyle(student.passed ? .green : .red)

            Text("Grade: \(student.grade)")
                .font(.title2)

            Spacer()
        }
        .padding()
        .navigationTitle("Student Details")
    }
}

#Preview {
    ContentView()
}
