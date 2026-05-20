//
//  DeviceCard.swift
//  Findew
//
//  Created by 내꺼다 on 11/4/25.
//

import SwiftUI

struct DeviceDisplayCard: View, Equatable {
    // MARK: - Properties
    let device: DeviceDTO
    @Binding var isSelected: Bool
    var onTap: (() -> Void)?
    
    // MARK: - Equatable
    static func == (lhs: DeviceDisplayCard, rhs: DeviceDisplayCard) -> Bool {
        lhs.device == rhs.device && lhs.isSelected == rhs.isSelected
    }
    
    // MARK: - DeviceDisplayCardConstants
    fileprivate enum DeviceDisplayCardConstants {
        static let cardPadding: EdgeInsets = .init(top: 28, leading: 20, bottom: 28, trailing: 20)
        static let middleCardVSpacing: CGFloat = 12
        static let middleCardHSpacing: CGFloat = 5
        static let serialBoxPadding: EdgeInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        static let patientInfoWidth: CGFloat = 123
        static let checkmarkSize: CGFloat = 28
        static let checkmarkIconSize: CGFloat = 20
        
        static let batterySize: CGSize = .init(width: 75, height: 33)
        static let batteryPadding: CGFloat = 5
        
        static let cornerRadius: CGFloat = 24
        static let serialBoxRadius: CGFloat = 6
        
        static let noExistPatient: String = "환자 미할당 기기"
        static let checkMark: String = "checkmark"
    }
    
    // MARK: - Init
    init(device: DeviceDTO, isSelected: Binding<Bool>, onTap: (() -> Void)? = nil) {
        self.device = device
        self._isSelected = isSelected
        self.onTap = onTap
    }
    
    // MARK: - Computed Properties
    private var batteryType: BatteryEnum {
        if device.batteryLevel > 70 {
            return .highBattery
        } else if device.batteryLevel > 30 {
            return .middleBattery
        } else {
            return .lowBattery
        }
    }
    
    private var cardBackgroundColor: Color {
        return device.batteryLevel <= 30 ? .red01 : .clear
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            onTap?()
        }) {
            HStack(spacing: .zero) {
                leftContent
                Spacer()
                centerContent
                Spacer().frame(maxWidth: 10)
                batteryInfoProgress
            }
            .padding(DeviceDisplayCardConstants.cardPadding)
            .glassEffect(.regular.tint(cardBackgroundColor), in: .rect(cornerRadius: DeviceDisplayCardConstants.cornerRadius, style: .continuous))
            .background {
                RoundedRectangle(cornerRadius: DeviceDisplayCardConstants.cornerRadius)
                    .fill(cardBackgroundColor)
            }
            .overlay(alignment: .topTrailing) {
                if isSelected {
                    checkmarkView
                        .padding(.top, 9)
                        .padding(.trailing, 10)
                }
            }
        }
        .disabled(onTap == nil)
    }
    
    // MARK: - Left
    /// 왼쪽 시리얼 표시 태그
    private var leftContent: some View {
        Text(device.serialNumber)
            .font(.b1)
            .foregroundColor(.black)
            .padding(DeviceDisplayCardConstants.serialBoxPadding)
            .background {
                RoundedRectangle(cornerRadius: DeviceDisplayCardConstants.serialBoxRadius)
                    .fill(Color.gray01)
            }
    }
    
    // MARK: - Center
    /// 가운데 환자 이름 및 병동 침대 번호
    private var centerContent: some View {
        HStack(spacing: DeviceDisplayCardConstants.middleCardHSpacing) {
            if let patient = device.patient {
                Text(patient.name)
                    .font(.b2)
                Text("(\(patient.ward)-\(patient.bed))")
                    .font(.b4)
            } else {
                Text(DeviceDisplayCardConstants.noExistPatient)
            }
        }
        .foregroundStyle(.gray09)
    }
    
    // MARK: - Battery View
    private var batteryInfoProgress: some View {
        HStack(spacing: .zero) {
            batteryProgressBar
            batteryHeader
        }
    }
    
    private var batteryProgressBar: some View {
        ZStack(alignment: .trailing) {
            RoundedRectangle(cornerRadius: batteryType.iconBatteryRoundness)
                .fill(.clear)
                .frame(maxWidth: DeviceDisplayCardConstants.batterySize.width, alignment: .trailing)
            
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: batteryType.iconBatteryRoundness)
                    .frame(
                        width: geo.size.width * CGFloat(device.batteryLevel) / 100.0,
                        height: batteryType.batteryHeight
                    )
                    .foregroundStyle(batteryType.iconBatteryColor)
            }
            .frame(maxWidth: DeviceDisplayCardConstants.batterySize.width, alignment: .trailing)
            
            Text("\(device.batteryLevel)%")
                .font(batteryType.iconFont)
                .foregroundStyle(.gray06)
            
        }
        .frame(height: DeviceDisplayCardConstants.batterySize.height)
        .padding(DeviceDisplayCardConstants.batteryPadding)
        .overlay(
            RoundedRectangle(cornerRadius: batteryType.iconStrokeBigRoundness)
                .stroke(batteryType.iconStrokeFontColor, lineWidth: batteryType.iconStrokeWeight)
        )
    }
    
    private var batteryHeader: some View {
        UnevenRoundedRectangle(bottomTrailingRadius: batteryType.iconStrokeSmallRoundness, topTrailingRadius: batteryType.iconStrokeSmallRoundness, style: .continuous)
            .fill(.clear)
            .strokeBorder(batteryType.iconStrokeFontColor, lineWidth: batteryType.iconStrokeWeight)
            .frame(width: batteryType.iconSmallSize.width, height: batteryType.iconSmallSize.height)
    }
    
    // MARK: - Checkmark View
    private var checkmarkView: some View {
        Image(systemName: DeviceDisplayCardConstants.checkMark)
            .symbolRenderingMode(.palette)
            .foregroundStyle(.white)
            .padding(DeviceDisplayCardConstants.batteryPadding)
            .background(
                Circle()
                    .fill(.blue05)
            )
    }
}
