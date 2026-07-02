//
//  IlhaView.swift
//  treasurehunt
//

import SwiftUI

struct IlhaView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            // Background: Solid light cyan (Ciano bem claro)
            Color(red: 0.9, green: 0.97, blue: 0.98)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header Icon
                VStack(spacing: 8) {
                    Image(systemName: "palmtree.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(.cyan)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                    
                    Text("Ilha Misteriosa")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundStyle(.black)
                }
                
                // Description Card
                VStack(spacing: 16) {
                    Text("Diário de Bordo:")
                        .font(.headline)
                        .foregroundStyle(.cyan)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Você desembarcou na praia de areia preta. O vento uiva entre as palmeiras e um caminho escuro leva direto para o interior da floresta fechada.")
                        .font(.body)
                        .foregroundStyle(.black.opacity(0.8))
                        .lineSpacing(4)
                }
                .padding(20)
                .background(Color.black.opacity(0.04))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black.opacity(0.1), lineWidth: 1)
                )
                .padding(.horizontal)
                
                Spacer()
                
                // Navigation Action
                NavigationLink(value: "floresta") {
                    HStack {
                        Text("Entrar na Floresta")
                            .fontWeight(.bold)
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.cyan)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                    .shadow(color: .cyan.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding()
        }
        .navigationTitle("A Praia")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        IlhaView(path: .constant(NavigationPath()))
    }
}
