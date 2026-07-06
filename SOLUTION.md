# Resoluções — Workshop SwiftUI Navigation Stack 🗝️
Este documento contém as soluções passo a passo ("hacks") para destravar a navegação de cada bloco do workshop.

---

## 🏝️ Bloco 1 — Zarpar

**Problema:** O botão "Iniciar Jornada" não navega e a visualização inicial está quebrada.
**Solução:** Envolver a VStack principal de `ContentView` em um `NavigationStack`.

### Modificação no arquivo [ContentView.swift](treasurehunt/ContentView.swift):
Substitua o início do `body`:
```swift
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                ZStack {
                    // ... conteúdo existente ...
                }
            }
            // Registro de rotas baseadas em Strings
            .navigationDestination(for: String.self) { rota in
                // ...
            }
        }
    }
```

---

## 🗺️ Bloco 2 — Ilha → Floresta → Rio

**Problema:** Os botões comuns não efetuam a navegação no histórico.
**Solução:** Substituir `Button` por `NavigationLink` apontando para o respectivo valor da rota, e implementar o pop to root no botão de explorar mais.

### 1. Modificação no arquivo [ContentView.swift](treasurehunt/ContentView.swift):
Troque o botão de iniciar por um `NavigationLink`:
```swift
                    // Substitua:
                    // Button(action: { ... }) { ... }
                    // Por:
                    NavigationLink(value: "ilha") {
                        HStack {
                            Text("Iniciar Jornada ⛵️")
                                .fontWeight(.black)
                                .font(.headline)
                            Image(systemName: "arrow.right")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .foregroundStyle(.black)
                        .cornerRadius(12)
                        .shadow(color: .yellow.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
```

### 2. Modificação no arquivo [IlhaView.swift](treasurehunt/GameViews/IlhaView.swift):
Troque o botão por um `NavigationLink` enviando `"floresta"`:
```swift
                // Substitua o Button por:
                NavigationLink(value: "floresta") {
                    HStack {
                        Text("Entrar na Floresta")
                            .fontWeight(.bold)
                        Image(systemName: "arrow.right.circle.fill")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow)
                    .foregroundStyle(.black)
                    .cornerRadius(12)
                    .shadow(color: .yellow.opacity(0.3), radius: 10, x: 0, y: 5)
                }
```

### 3. Modificação no arquivo [FlorestaView.swift](treasurehunt/GameViews/FlorestaView.swift):
Troque o botão por um `NavigationLink` enviando `"rio"`:
```swift
                // Substitua o Button por:
                NavigationLink(value: "rio") {
                    HStack {
                        Text("Seguir para o Rio")
                            .fontWeight(.bold)
                        Image(systemName: "drop.fill")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                    .shadow(color: .green.opacity(0.3), radius: 10, x: 0, y: 5)
                }
```

### 4. Modificação no arquivo [RioView.swift](treasurehunt/GameViews/RioView.swift):
Zerar o caminho de navegação (`path`) ao explorar mais a ilha (pop to root):
```swift
    private func explorarMais() {
        path = NavigationPath()
    }
```

---

## 🐻 Bloco 3 — Urso e volta na ilha

**Problema:** Ações de fuga, dar a volta na ilha e voltar ao barco não funcionam ou não manipulam a rota corretamente (e o botão de retorno da topbar sumiu).
**Solução:** Alterar programaticamente a propriedade `@Binding var path`.

### Modificação no arquivo [CriaturaView.swift](treasurehunt/GameViews/CriaturaView.swift):
```swift
    // Voltar apenas 1 tela (pop simples)
    private func fugir() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    // Empilhar uma nova tela de ilha manualmente
    private func darAVolta() {
        path.append("ilha")
    }
    
    // Voltar tudo (pop to root)
    private func voltarParaOBarco() {
        path = NavigationPath()
    }
```

---

## 🔑 Bloco 4 — Baú e premiação

**Problema:** O modelo `Baú` não compila ao tentar empilhar, o destino não responde, e a abertura do baú não realiza a navegação.
**Solução:** Adicionar conformidade `Hashable` ao `Baú`, registrar `.navigationDestination(for: Baú.self)` na ContentView e usar `NavigationLink` para abrir a premiação.

### 1. Modificação no arquivo [CriaturaView.swift](treasurehunt/GameViews/CriaturaView.swift):
Descomente a linha que passa o objeto `Baú` no `path.append` e comente a linha que passa a String `"bau"`:
```swift
                    // Action 4: Confront the Bear (Bloco 4 requires switching to Baú object)
                    Button(action: {
                        // 1. Comentar a linha abaixo (navegação genérica por String)
                        // path.append("bau")
                        
                        // 2. Descomentar a linha com a struct Baú
                        let meuBau = Baú(id: UUID(), temChave: true)
                        path.append(meuBau) // <- Isso causará erro de compilação inicialmente!
                    }) {
```

### 2. Modificação no arquivo [BauView.swift](treasurehunt/GameViews/BauView.swift):
Adicione a conformidade `Hashable` na struct `Baú`:
```swift
struct Baú: Hashable {
    let id: UUID
    let temChave: Bool
}
```

Substitua o botão de abrir por um `NavigationLink` enviando o valor `"premiacao"`. Use `.disabled(!baú.temChave)` para que o link só funcione se o baú tiver a chave:
```swift
                    // Substitua o Button por:
                    NavigationLink(value: "premiacao") {
                        HStack {
                            Image(systemName: "key.fill")
                            Text("Usar Chave & Abrir")
                                .fontWeight(.bold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(baú.temChave ? Color.yellow : Color.gray)
                        .foregroundStyle(.black)
                        .cornerRadius(12)
                        .shadow(color: .yellow.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .disabled(!baú.temChave)
```

### 3. Modificação no arquivo [ContentView.swift](treasurehunt/ContentView.swift):
Registre as rotas na `ContentView.swift`. Adicione a rota `"premiacao"` no `String` destinations e ative o destino do `Baú`:
```swift
        // Registro de rotas baseadas em Strings
        .navigationDestination(for: String.self) { rota in
            switch rota {
            // ... outros cases ...
            case "premiacao":
                PremiacaoView()
            default:
                EmptyView()
            }
        }
        // Tratamento do baú do tesouro (Bloco 4)
        .navigationDestination(for: Baú.self) { baú in
            BauView(baú: baú, path: $path)
        }
```

---
⛵️ **Pronto! Com estas correções o jogo estará 100% jogável do início ao fim!**
