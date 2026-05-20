//
//  PatientDetailView.swift
//  Findew
//
//  Created by 진아현 on 11/16/25.
//

import SwiftUI
import MapKit

struct PatientDetailView: View {
    // MARK: - Property
    let detailPatientEnum: PatientEnum = .detail
    let patient: PatientDTO
    @Environment(\.dismiss) var dismiss
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 104.3235, longitude: 12.5432), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @Namespace var namespace
    
    // MARK:  - Constants
    fileprivate enum PatientDetailConstant {
        static let backgroundRadius: CGFloat = 34
        static let mainPadding: CGFloat = 30
        static let offsetPadding: (CGFloat,CGFloat) = (30, 20)
        
        static let infoPadding: EdgeInsets = .init(top: 30, leading: 19, bottom: 30, trailing: 30)
        
        static let titleSize: CGSize = .init(width: 93, height: 61)
        static let titleFont: Font = .symbolText01
        
        static let devicePadding: CGFloat = 8
        static let deviceColor: Color = .init(.gray01)
        
        static let detailFont: Font = .b1
        static let detailColor: Color = .init(.gray08)
    }
    
    // MARK: BODY
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            
            HStack {
                MapSection
                PatientInfoSection
            }
            .background {
                RoundedRectangle(cornerRadius: PatientDetailConstant.backgroundRadius)
                    .fill(.white)
                    .frame(maxWidth: .infinity)
            }
            
            closeBtn
                .offset(x: PatientDetailConstant.offsetPadding.0, y: PatientDetailConstant.offsetPadding.1)
        }
    }
    
    private var closeBtn: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image(systemName: "xmark")
                .renderingMode(.template)
                .resizable()
                .tint(.black)
                .scaledToFit()
                .frame(width: 20, height: 20)
        })
        .padding()
        .glassEffect(.regular.interactive(), in: .circle)
        .glassEffectID("xmark", in: namespace)
        .contentShape(.circle)
        .allowsHitTesting(true)
    }
    
    // MARK: - MAP
    @ViewBuilder
    private var MapSection: some View {
        if let device = patient.device {
            IndoorMapView(floor: device.currentZone?.floor ?? 1)
                .equatable()
                .frame(minWidth: 600)
        }
    }
    
    // MARK: - INFO
    private var PatientInfoSection: some View{
        VStack(alignment: .leading) {
            Text(detailPatientEnum.title)
                .font(detailPatientEnum.titleFont)
                .frame(height: PatientDetailConstant.titleSize.height)
            
            let components = detailPatientEnum.patientComponents
            
            ForEach(components, id: \.self) { component in
                PatientInfo(component: component)
                
                if component != components.last {
                    Divider()
                }
            }
            
            Spacer()
        }
        .padding(PatientDetailConstant.infoPadding)
    }
    
    @ViewBuilder
    private func PatientInfo(component: PatientComponentsEnum) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(component.title)
                .font(PatientDetailConstant.titleFont)
                .foregroundStyle(detailPatientEnum.titleFontColor)
                .frame(width: PatientDetailConstant.titleSize.width, height: PatientDetailConstant.titleSize.height, alignment: .leading)
            
            valueView(for: component)
                .font(PatientDetailConstant.detailFont)
                .foregroundStyle(PatientDetailConstant.detailColor)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minWidth: 400)
    }
    
    @ViewBuilder
    private func valueView(for component: PatientComponentsEnum) -> some View {
        switch component {
        case .name:
            Text(patient.name)
        case .ward:
            Text("\(patient.ward)-\(patient.bed)")
        case .department:
            Text(patient.department.name)
        case .device:
            Text(patient.device?.serialNumber ?? "")
                .padding(PatientDetailConstant.devicePadding)
                .background(
                    Capsule()
                        .fill(PatientDetailConstant.deviceColor)
                )
        case .memo:
            Group {
                if let memo = patient.memo, !memo.isEmpty {
                    Text(memo)
                } else {
                    Text("작성된 기타 사항이 없습니다.")
                }
            }
        case .bed:
            Text("")
        }
    }
}
