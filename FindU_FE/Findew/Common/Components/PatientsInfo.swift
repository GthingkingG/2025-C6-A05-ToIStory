//
//  PatientsInfo.swift
//  Findew
//
//  Created by Apple Coding machine on 11/3/25.
//

import SwiftUI

struct PatientsInfo: View {
    // MARK: - Property
    let info: PatientComponentsEnum
    @Binding var value: PatientGenerateRequest
    var departments: [DepartmentDTO]
    var devices: [DeviceDTO]
    @FocusState var isFocused: PatientComponentsEnum?
    
    // MARK: - Constants
    fileprivate enum PatientsConstant {
        static let wardSpacing: CGFloat = 4
        
        static let titleSize: CGSize = .init(width: 110, height: 50)
        static let fieldWidth: (CGFloat, CGFloat) = (70,80)
        static let labelPadding: EdgeInsets = .init(top: 3, leading: 10, bottom: 3, trailing: 10)
        
        static let namePlaceholder: String = "환자 이름을 작성해주세요"
        static let wardPlaceholder: String = "병동 번호"
        static let bedPlaceholder: String = "침대 번호"
    }
    
    // MARK: - Init
    init(
        info: PatientComponentsEnum,
        value: Binding<PatientGenerateRequest>,
        departments: [DepartmentDTO] = [],
        devices: [DeviceDTO] = []
    ) {
        self.info = info
        self._value = value
        self.departments = departments
        self.devices = devices
    }
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .top, spacing: 30) {
            leftTitle
            infoContent
            Spacer()
        }
        .frame(alignment: .leading)
    }
    // MARK: - Left
    private var leftTitle: some View {
        Text(info.title)
            .font(.b5)
            .frame(width: PatientsConstant.titleSize.width)
    }
    
    // MARK: - Right
    @ViewBuilder
    private var infoContent: some View {
        switch info {
        case .name:
            generateTextField(PatientsConstant.namePlaceholder, value: $value.name, equals: .name)
        case .ward, .bed:
            wardBed
        case .department, .device:
            menuContent
        case .memo:
            generateOptionalTextField(info.placeholderContents ?? "", value: $value.memo, isEtc: true)
        }
    }
    
    // MARK: - Department&Device
    private var menuContent: some View {
        Menu(selectedValue ? selectedMenuText : info.placeholderContents ?? "",
             content: {
            menuItems
        })
        .tint(.black)
        .padding(PatientsConstant.labelPadding)
        .glassEffect(.regular.interactive(), in: Capsule())
    }
    
    @ViewBuilder
    private var menuItems: some View {
        switch info {
        case .department:
            if departments.isEmpty {
                Text("등록된 부서가 없습니다.")
            } else {
                ForEach(departments, id: \.id) { department in
                    Button(action: {
                        value.departmentId = department.id
                    }) {
                        Text(department.name)
                    }
                }
            }
        case .device:
            if devices.isEmpty {
                Text("등록된 기기가 없습니다.")
            } else {
                ForEach(devices, id: \.id) { device in
                    Button(action: {
                        value.deviceSerial = device.serialNumber
                    }, label: {
                        Text(device.serialNumber)
                    })
                }
            }
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var menuLabel: some View {
        Group {
            if selectedValue {
                Label(title: {
                    Text(selectedMenuText)
                        .font(.b1)
                        .foregroundStyle(.black)
                }, icon: {
                    Image(systemName: "stethoscope")
                        .tint(.black)
                })
            } else {
                Label(title: {
                    placeText(info.placeholderContents ?? "")
                }, icon: {
                    
                })
            }
        }
        .padding(PatientsConstant.labelPadding)
        .background {
            Capsule()
                .fill(.gray01)
        }
    }
    
    private var selectedMenuText: String {
        switch info {
        case .department:
            return departments.first(where: { $0.id == value.departmentId})?.name ?? ""
        case .device:
            return value.deviceSerial ?? ""
        default:
            return ""
        }
    }
    
    private var selectedValue: Bool {
        switch info {
        case .department:
            return departments.first(where: { $0.id == value.departmentId }) != nil
        case .device:
            return value.deviceSerial?.isEmpty == false
        default:
            return false
        }
    }
    
    // MARK: - Ward & Bed
    private var wardBed: some View {
        HStack(alignment: .center, spacing: PatientsConstant.wardSpacing, content: {
            generateTextField(PatientsConstant.wardPlaceholder, value: $value.ward, type: .numberPad, equals: .ward)
                .frame(maxWidth: PatientsConstant.fieldWidth.0)
            
            Text("-")
                .font(.b1)
                .foregroundStyle(.black)
                .padding(.horizontal, 10)
            
            generateIntTextField(PatientsConstant.bedPlaceholder, value: $value.bed, equals: .bed)
                .frame(maxWidth: PatientsConstant.fieldWidth.1)
        })
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - TextField
    @ViewBuilder
    private func generateTextField(_ placeholder: String, value: Binding<String>, isEtc: Bool = false, type: UIKeyboardType = .default, equals: PatientComponentsEnum) -> some View {
        if isEtc {
            TextField(text: value, axis: .vertical, label: { placeText(placeholder) })
        } else {
            TextField("", text: value, prompt: placeText(placeholder))
                .font(.b1)
                .foregroundStyle(.black)
                .keyboardType(type)
                .submitLabel(.next)
                .focused($isFocused, equals: equals)
                .onSubmit {
                    isFocused = equals.nextField
                }
        }
    }
    
    @ViewBuilder
    private func generateOptionalIntTextField(_ placeholder: String, value: Binding<Int?>, equals: PatientComponentsEnum) -> some View {
        let binding = Binding<String>(
            get: {
                if let intValue = value.wrappedValue {
                    return String(intValue)
                }
                return ""
            },
            set: { newValue in
                if newValue.isEmpty {
                    value.wrappedValue = nil
                } else {
                    value.wrappedValue = Int(newValue)
                }
            }
        )
        
        TextField("", text: binding, prompt: placeText(placeholder))
            .keyboardType(.numberPad)
            .textFieldStyle(.plain)
            .font(.b1)
            .foregroundStyle(.black)
            .focused($isFocused, equals: equals)
            .onSubmit {
                isFocused = equals.nextField
            }
    }
    
    @ViewBuilder
    private func generateOptionalTextField(_ placeholder: String, value: Binding<String?>, isEtc: Bool = false) -> some View {
        let binding = Binding<String>(
            get: { value.wrappedValue ?? "" },
            set: { value.wrappedValue = $0.isEmpty ? nil : $0 }
        )
        
        TextField("", text: binding, axis: isEtc ? .vertical : .horizontal)
    }
    
    private func placeText(_ text: String) -> Text {
        Text(text)
            .font(.b1)
            .foregroundStyle(.gray03)
    }
    
    /// 수정용
    @ViewBuilder
    private func generateIntTextField(_ placeholder: String, value: Binding<Int>, equals: PatientComponentsEnum) -> some View {
        let binding = Binding<String>(
            get: {
                return value.wrappedValue == 0 ? "" : String(value.wrappedValue)
            },
            set: { newValue in
                if newValue.isEmpty {
                    value.wrappedValue = 0
                } else if let intValue = Int(newValue) {
                    value.wrappedValue = intValue
                }
            }
        )
        
        TextField("", text: binding, prompt: placeText(placeholder))
            .keyboardType(.numberPad)
            .textFieldStyle(.plain)
            .font(.b1)
            .foregroundStyle(.black)
            .focused($isFocused, equals: equals)
            .onSubmit {
                isFocused = equals.nextField
            }
    }
    
    
}
