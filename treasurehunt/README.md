# Workshop SwiftUI Navigation Stack: Náufragos & Exploradores 🏴‍☠️

Bem-vindo ao workshop de **SwiftUI Navigation Stack**.

Neste desafio, você assume o papel de um explorador náufrago num arquipélago misterioso. Pra encontrar o tesouro lendário, precisa consertar a navegação do aplicativo, ilha por ilha.

Este README é dividido em duas partes:

1. **Parte Teórica** — todos os conceitos, formas de fazer, benefícios, quando usar cada coisa. Serve como material consultivo depois do workshop.
2. **Guia de Resolução** — passo a passo de cada bloco, o que fazer, por que fazer, e como testar.

---

## Índice

**Parte 1 — Teoria**
- [O que é uma pilha (Stack)](#o-que-é-uma-pilha-stack)
- [NavigationStack: o contêiner](#navigationstack-o-contêiner)
- [NavigationPath: o array mágico](#navigationpath-o-array-mágico)
- [NavigationLink: empilhando com toque](#navigationlink-empilhando-com-toque)
- [navigationDestination: o mapa de rotas](#navigationdestination-o-mapa-de-rotas)
- [Push: empilhar tela](#push-empilhar-tela)
- [Pop: desempilhar tela](#pop-desempilhar-tela)
- [Pop to Root: voltar ao início](#pop-to-root-voltar-ao-início)
- [Back Button Oculto](#back-button-oculto)
- [Hashable: por que é obrigatório](#hashable-por-que-é-obrigatório)
- [Data-Driven Navigation](#data-driven-navigation)
- [String vs Struct no path](#string-vs-struct-no-path)
- [NavigationLink vs Button](#navigationlink-vs-button)
- [Compartilhando o path (@Binding vs Router)](#compartilhando-o-path-binding-vs-router)
- [Closures](#closures)

**Parte 2 — Resolução do Workshop**
- [Bloco 1: Zarpar](#bloco-1-zarpar)
- [Bloco 2: Ilha → Floresta → Rio](#bloco-2-ilha--floresta--rio)
- [Bloco 3: Urso e Volta na Ilha](#bloco-3-urso-e-volta-na-ilha)
- [Bloco 4: Baú e Premiação](#bloco-4-baú-e-premiação)

---

# Parte 1 — Teoria

## O que é uma pilha (Stack)

Antes de qualquer coisa: navegação no iOS funciona como uma **pilha de pratos**.

Você só coloca prato novo no topo. Só tira o prato do topo. Não puxa do meio.

- Colocar prato no topo = **push** (empilhar). Uma tela nova aparece.
- Tirar prato do topo = **pop** (desempilhar). Volta pra tela anterior.
- Tirar todos = **pop to root**. Volta pra tela raiz.

O `NavigationStack` do SwiftUI é o gerenciador dessa pilha.

**Exemplo visual do jogo:**

```
┌─────────────────┐
│  CriaturaView   │  ← TOPO (o usuário vê essa)
├─────────────────┤
│    RioView      │
├─────────────────┤
│  FlorestaView   │
├─────────────────┤
│   IlhaView      │
├─────────────────┤
│  ContentView    │  ← BASE (raiz — nunca sai)
└─────────────────┘
path = ["ilha", "floresta", "rio", "criatura"]
```

A ordem no path é a mesma ordem da pilha, de baixo pra cima.

---

## NavigationStack: o contêiner

Sem NavigationStack, nada de navegação funciona. É o componente que gerencia a pilha inteira.

**Duas formas de usar:**

**Forma 1 — sem controle programático:**

```swift
NavigationStack {
    NavigationLink("Ir", destination: OutraView())
}
```

Funciona pra navegação simples. Mas você não tem controle: não consegue voltar ao início por código, não sabe quantas telas estão empilhadas, não consegue empilhar por código.

**Forma 2 — com path (a que usamos):**

```swift
NavigationStack(path: $path) {
    // conteúdo
}
```

Você tem controle total. Pode empilhar, desempilhar, esvaziar tudo por código. É essa que o workshop usa.

**Regra importante:** só existe **um** NavigationStack por hierarquia. Se uma view filha colocar outro NavigationStack dentro, dá bug (barra de navegação duplicada). O stack fica na raiz.

**Alternativa histórica:** antes do iOS 16 existia `NavigationView`. Foi **deprecado** porque não permitia pop to root sem hacks, não tinha controle programático, e o comportamento no iPad era inconsistente. Se você abrir código antigo e ver NavigationView, saiba que já está desatualizado.

---

## NavigationPath: o array mágico

O `NavigationPath` é a variável que representa a pilha. Cada item nele é uma tela empilhada.

```swift
@State private var path = NavigationPath()
```

O `@State` faz o SwiftUI observar essa variável. Quando ela muda, o SwiftUI redesenha a navegação — empilha ou desempilha telas com animação.

**Por que NavigationPath e não `[String]`?**

`NavigationPath` aceita **tipos mistos**:

```swift
path.append("ilha")                        // String
path.append(Baú(id: ..., temChave: true))  // Struct
path.append(42)                            // Int
// Tudo no mesmo path
```

Um `[String]` só aceitaria Strings. Como no jogo empilhamos String **e** a struct `Baú`, precisamos do NavigationPath. Ele aceita qualquer tipo Hashable.

**Se você usasse `[String]`:**

```swift
@State private var path: [String] = []
```

Funcionaria pra rotas simples ("ilha", "floresta"), mas quebra na hora que precisa passar dados junto (o baú com chave).

**Operações principais:**

```swift
path.append("valor")               // push (empilha)
path.removeLast()                  // pop (desempilha 1)
path.removeLast(3)                 // desempilha 3
path.removeLast(path.count)        // pop to root
path = NavigationPath()            // pop to root (forma limpa)
path.count                         // quantas telas empilhadas
path.isEmpty                       // true se só a raiz está visível
```

---

## NavigationLink: empilhando com toque

O componente que o usuário toca pra ir pra outra tela. Tem duas formas — entenda a diferença.

**Forma antiga (destination):**

```swift
NavigationLink(destination: FlorestaView()) {
    Text("Ir")
}
```

Problemas:
- A FlorestaView é criada **imediatamente**, mesmo antes do toque. Desperdiça memória.
- Não interage com NavigationPath. Não tem como fazer pop to root.
- O link **sabe** qual view abre. Acoplamento forte.

**Forma moderna (value):**

```swift
NavigationLink(value: "floresta") {
    Text("Ir")
}
```

Benefícios:
- Envia um **valor**, não uma view. Quem decide qual view abre é o `navigationDestination`.
- Lazy: a view só é criada quando necessário.
- Interage com o path. Deep linking, pop to root, tudo funciona.
- Desacoplado: o link não sabe qual view vai aparecer.

**O que acontece por baixo dos panos quando o usuário toca:**

1. SwiftUI faz `path.append("floresta")` internamente.
2. O NavigationStack vê que o path mudou.
3. Procura um `.navigationDestination(for: String.self)`.
4. Executa o closure passando `"floresta"`.
5. Empilha a view retornada com animação slide.

---

## navigationDestination: o mapa de rotas

Conecta um **tipo** a uma **view**:

```swift
.navigationDestination(for: String.self) { valor in
    switch valor {
    case "ilha": IlhaView()
    case "floresta": FlorestaView()
    default: EmptyView()
    }
}
```

Quando alguém empilha uma String no path, o NavigationStack executa esse closure passando a String. Você retorna a view certa.

**Múltiplos destinations por tipo:**

```swift
.navigationDestination(for: String.self) { ... }  // Strings
.navigationDestination(for: Baú.self) { ... }     // Structs Baú
.navigationDestination(for: Int.self) { ... }     // Ints
```

Cada tipo precisa do seu próprio destination. Quando o path recebe um valor, o stack verifica o tipo e despacha pro destination correto.

**Regras:**

- Deve ficar **dentro** do NavigationStack, geralmente na view raiz.
- Um destination por tipo. Se registrar dois pro mesmo tipo, o segundo é ignorado.
- Se o path receber um tipo sem destination registrado, nada acontece (sem crash, sem navegação).

**Alternativa: roteamento por enum**

Em vez de String, pode usar um enum:

```swift
enum Rota: Hashable {
    case ilha
    case floresta
    case bau(temChave: Bool)  // leva dados junto!
}

.navigationDestination(for: Rota.self) { rota in
    switch rota {
    case .ilha: IlhaView()
    case .floresta: FlorestaView()
    case .bau(let temChave): BauView(temChave: temChave)
    }
}
```

**Benefício:** o compilador garante que você não erre o nome (`"ilah"` viraria erro em tempo de compilação, não em runtime). E cada case pode carregar dados diferentes.

**Quando usar cada abordagem:**

- **String**: workshops, protótipos, apps pequenos. Simples e didático.
- **Struct**: quando a rota precisa carregar dados junto (como o `Baú`).
- **Enum**: apps de produção. Type-safe, cada rota pode ter dados diferentes.

---

## Push: empilhar tela

Duas formas de empilhar:

**Declarativa** — com `NavigationLink(value:)`. O toque **sempre** navega:

```swift
NavigationLink(value: "floresta") {
    Text("Ir")
}
```

**Programática** — com `path.append()` dentro de código:

```swift
Button("Ir") {
    // executa lógica antes
    salvarProgresso()
    // depois navega
    path.append("floresta")
}
```

**Quando usar cada uma:**

Use **NavigationLink(value:)** quando o toque é a navegação. Sem condição, sem lógica no meio. É o caso mais comum.

Use **Button + append** quando existe lógica entre o toque e o push: validação de formulário, salvamento, chamada de rede, permissão. Ou quando a navegação é disparada por algo que não é toque (timer, notificação, resposta de servidor).

---

## Pop: desempilhar tela

Três formas de voltar 1 tela:

**Botão nativo** — o "< Voltar" que aparece automaticamente no topo. Também funciona arrastando da borda esquerda.

**Por código com removeLast:**

```swift
if !path.isEmpty {
    path.removeLast()
}
```

**⚠️ Cuidado:** `removeLast()` num path vazio causa crash. Sempre verifica `!path.isEmpty` antes.

**Com @Environment(.dismiss):**

```swift
@Environment(\.dismiss) private var dismiss

Button("Voltar") { dismiss() }
```

Mais simples, não precisa acessar o path. Mas só volta 1 tela, sempre. Não permite pop to root nem pop de N telas.

**Pop de várias telas de uma vez:**

```swift
path.removeLast(2)  // volta 2 telas
path.removeLast(3)  // volta 3 telas
```

Útil pra pular telas intermediárias em fluxos condicionais.

---

## Pop to Root: voltar ao início

Substitui o path por vazio:

```swift
path = NavigationPath()
```

Todas as telas são desempilhadas de uma vez. O usuário volta direto pra raiz.

**Alternativa:**

```swift
path.removeLast(path.count)
```

Mesmo efeito. A primeira forma é mais usada porque é mais clara.

**Por que essa é uma das maiores vitórias do NavigationStack:**

No antigo NavigationView, fazer pop to root era um pesadelo. As alternativas eram:

- Variáveis `@State isActive` em cadeia — frágil e verboso.
- `NotificationCenter` pra sinalizar a raiz — hack feio.
- Interop com UIKit (`UINavigationController.popToRootViewController`) — quebra o modelo SwiftUI.

Com NavigationStack + NavigationPath, uma linha resolve.

---

## Back Button Oculto

Por padrão, toda tela empilhada mostra "< Título Anterior" no topo. Pra esconder:

```swift
.navigationBarBackButtonHidden(true)
```

**Quando usar:**

- Telas que exigem decisão do usuário antes de sair (como a CriaturaView do workshop — precisa escolher fugir, poção, ou enfrentar).
- Onboarding onde você não quer que o usuário volte pro passo anterior.
- Quando implementa um botão de voltar customizado.

**⚠️ Efeito colateral importante:** ocultar o botão **também desabilita** o gesto de swipe da borda esquerda pra voltar. Não tem como separar os dois no SwiftUI puro. Use com moderação.

**Botão de voltar customizado:**

```swift
.navigationBarBackButtonHidden(true)
.toolbar {
    ToolbarItem(placement: .navigationBarLeading) {
        Button {
            path.removeLast()
        } label: {
            HStack {
                Image(systemName: "chevron.left")
                Text("Meu Voltar")
            }
        }
    }
}
```

---

## Hashable: por que é obrigatório

O NavigationPath tem uma regra: só aceita valores **Hashable**.

```swift
struct Baú: Hashable {  // ← sem isso, o append não compila
    let id: UUID
    let temChave: Bool
}
```

**Por quê?** Porque o NavigationPath precisa comparar e identificar valores internamente. Hashable dá a cada valor uma "impressão digital" numérica única (o hash):

```
Baú(id: ABC, temChave: true)   → hash 483920174
Baú(id: XYZ, temChave: false)  → hash 192837465
```

**Quem já é Hashable de fábrica:** String, Int, Bool, Double, UUID, Date, URL. Por isso `path.append("ilha")` funciona sem configuração.

**Structs suas** não são Hashable por padrão. Precisa declarar `: Hashable`. Quando todas as propriedades já são Hashable (como UUID + Bool), o Swift **sintetiza** o hash automaticamente — você não implementa nada.

**Se uma propriedade não fosse Hashable** (ex: uma UIImage), você teria que implementar manualmente:

```swift
struct Baú: Hashable {
    let id: UUID
    let imagem: UIImage  // UIImage não é Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // usa só o id pro hash
    }

    static func == (lhs: Baú, rhs: Baú) -> Bool {
        lhs.id == rhs.id
    }
}
```

**Hashable vs Equatable vs Identifiable:**

- `Equatable` — permite comparar com `==`
- `Hashable` — estende Equatable + gera hash. Obrigatório pra NavigationPath, Set, chaves de Dictionary.
- `Identifiable` — tem um `id`. Obrigatório pra List/ForEach.

Hashable **inclui** Equatable. Identifiable é separado.

---

## Data-Driven Navigation

O conceito central do NavigationStack. Significa: **o dado manda, a tela obedece**.

**Antes (navegação por ação):**

```swift
NavigationLink(destination: FlorestaView()) { Text("Ir") }
```

O código diz "abre essa view específica". A tela está hardcoded. Se quiser mudar, muda o link.

**Depois (data-driven):**

```swift
NavigationLink(value: "floresta") { Text("Ir") }
```

O código diz "coloca esse dado no path". Não menciona nenhuma view. Em outro lugar, o mapa de rotas transforma dado em view:

```swift
.navigationDestination(for: String.self) { rota in
    switch rota {
    case "floresta": FlorestaView()
    // ...
    }
}
```

**O que isso destrava:**

- **Deep linking**: uma notificação pode montar `path.append("ilha"); path.append("floresta")` e levar o usuário direto pra 2 telas de profundidade sem tocar em nada.
- **Salvar e restaurar navegação**: o path é só dado. Serializa, salva, restaura depois.
- **Pop to root em 1 linha**: `path = NavigationPath()`.
- **Testabilidade**: pra testar navegação, verifica o path — não precisa simular toques.
- **Desacoplamento**: cada tela não sabe qual é a próxima. O mapa de rotas centraliza isso.

**Por que "data-driven":** a fonte de verdade é o **dado** (o path). A **UI** (as telas) é consequência automática. Você gerencia dados, não telas.

---

## String vs Struct no path

**String** é um endereço. Só diz **pra onde ir**.

**Struct** é um endereço com a encomenda dentro. Diz pra onde ir **e leva os dados junto**.

**Exemplo com String:**

```swift
path.append("bau")

// Precisa de variável separada pra dados:
@State var bauTemChave = true

// No destination:
case "bau": BauView(temChave: bauTemChave)
```

Problemas: dois lugares pra sincronizar (path + variável), fácil ficar dessincronizado, não escala.

**Exemplo com Struct:**

```swift
let meuBau = Baú(id: UUID(), temChave: true)
path.append(meuBau)

// No destination:
.navigationDestination(for: Baú.self) { baú in
    BauView(baú: baú)
}
```

Um lugar, um valor, dados viajam junto com a navegação. Impossível dessincronizar.

**Quando usar cada uma:**

- **String** pra rotas simples sem dados ("ilha", "floresta").
- **Struct** quando a tela precisa de dados pra funcionar (baú com chave, produto com id, usuário com detalhes).

---

## NavigationLink vs Button

Ambos podem levar a uma navegação. A diferença está no **controle**.

**NavigationLink** — o toque **é** a navegação. Sempre. Sem lógica no meio.

```swift
NavigationLink(value: "floresta") { Text("Ir") }
```

**Button + path.append()** — o toque **dispara código**, e o código decide se navega.

```swift
Button("Ir") {
    if podeAvancar {
        path.append("floresta")
    }
}
```

**Quando usar cada um:**

- **NavigationLink**: navegação incondicional, imediata. Lista de itens, menu, botão "Próximo".
- **Button + append**: validação de formulário, salvamento antes de navegar, permissão condicional, lógica de negócio.

**Erro comum:** usar NavigationLink pra tudo e depois tentar interceptar com `.simultaneousGesture` pra rodar lógica antes. É frágil. Se precisa de lógica antes, use Button.

**Direção oposta:** usar Button + append pra tudo, mesmo sem lógica. Funciona, mas você perde a semântica — o SwiftUI não sabe que é navegação, então não aplica comportamentos automáticos (setas em Lists, acessibilidade, otimizações).

**Regra prática:** se o toque **é** navegação, NavigationLink. Se o toque **pode levar** à navegação, Button.

**NavigationLink não faz pop.** Só faz push. Pra voltar você **precisa** de Button ou do botão nativo. NavigationLink com valor de tela anterior não volta — cria uma nova cópia empilhada.

---

## Compartilhando o path (@Binding vs Router)

O path vive na view raiz. As views filhas precisam de acesso pra fazer push/pop. Duas abordagens:

**Abordagem 1 — @Binding (prop drilling):**

```swift
// ContentView
@State private var path = NavigationPath()
IlhaView(path: $path)  // passa o binding

// IlhaView
@Binding var path: NavigationPath
FlorestaView(path: $path)  // repassa

// FlorestaView
@Binding var path: NavigationPath
RioView(path: $path)  // repassa de novo
```

Problemas:
- Cada view recebe e repassa o binding.
- Se adicionar tela no meio, precisa alterar todas.
- View "IlhaView" precisa saber que existe view "FlorestaView" pra passar o binding pra ela.

**Abordagem 2 — Router com @EnvironmentObject (a refatorada):**

```swift
// Router.swift
class Router: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ route: String) { path.append(route) }
    func pop() { guard !path.isEmpty else { return }; path.removeLast() }
    func popToRoot() { path = NavigationPath() }
}

// App
@StateObject private var router = Router()

ContentView()
    .environmentObject(router)

// Qualquer view em qualquer profundidade
@EnvironmentObject var router: Router

Button("Voltar") { router.pop() }
```

Benefícios:
- Zero prop drilling. Adicionar tela nova? Zero alteração nas outras.
- Lógica de navegação centralizada. Se mudar `pop()` pra fazer log antes, muda num lugar só.
- Testável. Você testa o Router isoladamente.
- Legível. `router.popToRoot()` diz mais do que `path = NavigationPath()`.

**Quando usar cada uma:**

- **@Binding** — apps pequenos, com poucas telas, sem hierarquia profunda.
- **Router** — apps com múltiplas telas, hierarquia profunda, ou quando você quer separar responsabilidades.

**Regra dos @State objects:**

- `@StateObject` — onde o objeto é **criado** (dono). Uma vez.
- `@ObservedObject` — onde o objeto é **recebido** (não é dono).
- `@EnvironmentObject` — onde o objeto é **injetado** no ambiente.

**iOS 17+**: existe o macro `@Observable` que substitui `ObservableObject`. Mais moderno, mas requer iOS 17. Como o NavigationStack requer iOS 16, usamos `ObservableObject` pra manter compatibilidade.

---

## Closures

Closure é código entre `{ }` que você empacota e entrega pra alguém executar depois.

```swift
Button(action: { path.removeLast() })
//              └────────┬────────┘
//                   closure
```

Tudo entre `{` e `}` é a closure. O Button guarda ela e chama quando o usuário toca.

**Diferença entre função e closure:**

- Função tem nome, é declarada em lugar fixo, chamada por nome.
- Closure é anônima, escrita inline, guardada em variável ou passada como argumento.

Na prática são intercambiáveis. Você pode passar uma função no lugar de uma closure:

```swift
func fugir() { path.removeLast() }

Button(action: fugir)          // ✅ passa a função como valor
Button(action: fugir())        // ❌ chama a função AGORA (errado)
Button(action: { fugir() })    // ✅ closure que chama a função
```

**Captura de contexto:**

Closure pega variáveis do lugar onde foi escrita e leva junto:

```swift
Button(action: {
    path.removeLast()  // capturou "path" do escopo da View
})
```

A closure não recebeu `path` como parâmetro. Pegou de fora. Quando o Button executa a closure depois, ela ainda tem acesso a `path`.

**Quando extrair pra função nomeada:**

Se a closure tem mais de 3–4 linhas, extraia:

```swift
// Closure longa — confuso
Button(action: {
    salvarDados()
    validarFormulario()
    enviarAnalytics()
    path.append("destino")
})

// Função nomeada — claro
private func avancar() {
    salvarDados()
    validarFormulario()
    enviarAnalytics()
    path.append("destino")
}

Button(action: avancar)
```

---

# Parte 2 — Resolução do Workshop

Cada bloco tem um **problema**, uma **solução**, e a **explicação de por quê**.

---

## Bloco 1: Zarpar

**⏱️ Tempo:** 5 min
**🎯 Objetivo:** Fazer o botão "Iniciar Jornada" funcionar.

### Sintoma
Você toca "Iniciar Jornada" e nada acontece. O NavigationLink existe, mas não empilha.

### Por que não funciona
Falta o **NavigationStack**. Sem ele, `NavigationLink(value:)` não tem onde empilhar. É como ter uma pilha de pratos sem a mesa embaixo.

### Onde mexer
`ContentView.swift`

### Passo a passo

1. Abra ContentView.swift.
2. Localize o `var body`.
3. Envolva o conteúdo principal em um `NavigationStack(path: $path)`.
4. Adicione a variável `@State private var path = NavigationPath()` no topo da struct.
5. Adicione `.navigationDestination(for: String.self) { ... }` como modificador da view raiz.

### Código resultante (refatorado com Router)

```swift
struct ContentView: View {
    @EnvironmentObject var router: Router

    var body: some View {
        NavigationStack(path: $router.path) {
            // conteúdo
            .navigationDestination(for: String.self) { rota in
                switch rota {
                case "ilha": IlhaView()
                // outros cases
                default: EmptyView()
                }
            }
        }
    }
}
```

### Como testar
Toca "Iniciar Jornada". A IlhaView deve aparecer com animação slide da direita.

---

## Bloco 2: Ilha → Floresta → Rio

**⏱️ Tempo:** 12 min
**🎯 Objetivo:** Fazer os botões de "Entrar na Floresta", "Seguir pro Rio", "Explorar mais a ilha" funcionarem.

### Sintoma
Os botões existem mas são `Button` estáticos que não navegam.

### Por que não funciona
Botões `Button()` não navegam sozinhos. Ou vira `NavigationLink(value:)`, ou o Button chama `path.append()` no action.

### Onde mexer
- `IlhaView.swift`
- `FlorestaView.swift`
- `RioView.swift`

### Passo a passo

**IlhaView e FlorestaView** — trocar `Button` por `NavigationLink(value:)`:

```swift
// ❌ Antes
Button {
    // TODO
} label: {
    Text("Entrar na Floresta")
}

// ✅ Depois
NavigationLink(value: "floresta") {
    Text("Entrar na Floresta")
}
```

**RioView** tem dois botões:

**Botão 1** — "Entrar na Caverna" (navegação simples):

```swift
NavigationLink(value: "criatura") {
    Text("Entrar na Caverna Sombria")
}
```

**Botão 2** — "Explorar mais a ilha" (push programático):

Aqui é diferente. O sintoma pede pra usar `path.append("ilha")` **por código**, não NavigationLink. É pra ensinar push programático:

```swift
Button {
    router.push("ilha")  // ou path.append("ilha") sem Router
} label: {
    Text("Explorar mais a ilha")
}
```

### Por que os dois jeitos?

**NavigationLink(value:)** pra navegação direta. O toque é a navegação, sem condição.

**Button + push** pra situações onde você pode querer adicionar lógica antes (validar, logar, salvar). O workshop simula esse cenário na "Explorar mais a ilha" pra você aprender as duas formas.

### O que acontece na pilha

Ao tocar "Explorar mais a ilha" no Rio:

```
Antes:  path = ["ilha", "floresta", "rio"]
Depois: path = ["ilha", "floresta", "rio", "ilha"]
```

Uma **nova** IlhaView é empilhada — não é a original. A pilha pode ter a mesma tela repetida.

### Como testar
Percorra o fluxo inteiro: Home → Iniciar → Floresta → Rio → Caverna. Todos os botões devem empilhar telas com animação.

---

## Bloco 3: Urso e Volta na Ilha

**⏱️ Tempo:** 18 min
**🎯 Objetivo:** Fazer os botões "Fugir Correndo" e "Usar Poção" funcionarem, e entender por que o botão nativo de voltar sumiu.

### Sintomas
1. "Fugir Correndo" não faz nada.
2. "Usar Poção" não faz nada.
3. Sumiu o "< Voltar" no topo da tela.

### Por quê

**Sintomas 1 e 2:** as funções `fugir()` e `usarPocao()` estão com `// TODO` — sem implementação.

**Sintoma 3:** a CriaturaView tem `.navigationBarBackButtonHidden(true)` intencional. Isso força o usuário a decidir: fugir, poção, ou enfrentar. Não pode escapar pelo caminho fácil.

### Onde mexer
`CriaturaView.swift`

### Passo a passo

**1. Implementar `fugir()`** — pop simples (1 tela):

```swift
private func fugir() {
    if !path.isEmpty {
        path.removeLast()
    }
}
```

Ou com Router:

```swift
Button { router.pop() } label: {
    Text("Fugir Correndo")
}
```

**Por que `if !path.isEmpty`?** `removeLast()` num path vazio causa crash. Nunca deveria acontecer aqui (a CriaturaView só existe se tiver telas empilhadas), mas é boa prática defender contra edge cases. O Router encapsula essa verificação, então a View não precisa se preocupar.

**Pilha:**
```
Antes:  ["ilha", "floresta", "rio", "criatura"]
Depois: ["ilha", "floresta", "rio"]  → volta pra RioView
```

**2. Implementar `usarPocao()`** — pop to root:

```swift
private func usarPocao() {
    path = NavigationPath()
}
```

Ou com Router:

```swift
Button { router.popToRoot() } label: {
    Text("Usar Poção")
}
```

**Pilha:**
```
Antes:  ["ilha", "floresta", "rio", "criatura"]
Depois: []  → volta pra ContentView
```

**3. Sobre o back button oculto** — não precisa mexer, é intencional. Só entenda que:

```swift
.navigationBarBackButtonHidden(true)
```

Esconde o botão nativo. **Também desabilita o swipe da borda esquerda pra voltar.** Não tem como separar os dois no SwiftUI puro.

### Como testar
1. Chega até a CriaturaView.
2. Verifica que não tem "< Voltar" no topo.
3. Toca "Fugir Correndo" → volta pra RioView.
4. Chega na CriaturaView de novo.
5. Toca "Usar Poção" → volta pra ContentView (tela inicial).

---

## Bloco 4: Baú e Premiação

**⏱️ Tempo:** 10 min
**🎯 Objetivo:** Empilhar a struct `Baú`, registrar o destino, navegar pra premiação, e voltar ao início.

### Sintomas
1. Erro de compilação ao descomentar `path.append(meuBau)` na CriaturaView.
2. Mesmo compilando, tocar em "Enfrentar" não abre a BauView.
3. "Usar Chave & Abrir" não navega pra PremiacaoView.
4. "Comemorar e Fechar" na PremiacaoView não volta ao início.

### Onde mexer
- `BauView.swift` (a struct `Baú`)
- `ContentView.swift` (adicionar destination)
- `BauView.swift` (botão pra premiação)
- `PremiacaoView.swift` (botão pra fechar)

### Passo a passo

**1. Fazer a struct `Baú` conformar a `Hashable`**

Localiza a struct em `BauView.swift` (ou já no `Models/Bau.swift` se refatorado):

```swift
// ❌ Antes
struct Baú {
    let id: UUID
    let temChave: Bool
}

// ✅ Depois
struct Baú: Hashable {
    let id: UUID
    let temChave: Bool
}
```

**Por quê:** o NavigationPath só aceita valores Hashable. Sem essa palavra, o compilador rejeita `path.append(meuBau)` com "Type 'Baú' does not conform to protocol 'Hashable'".

Como UUID e Bool já são Hashable, o Swift **sintetiza** o hash automaticamente. Zero implementação manual.

**2. Registrar o destination pro tipo `Baú` na ContentView**

Dentro do NavigationStack, junto com o destination de String:

```swift
NavigationStack(path: $router.path) {
    // conteúdo
    .navigationDestination(for: String.self) { rota in
        // ...
    }
    .navigationDestination(for: Baú.self) { baú in
        BauView(baú: baú)
    }
}
```

**Por quê:** cada tipo empilhado precisa do seu destination. String vai pro destination de String. Baú vai pro destination de Baú. O NavigationStack despacha automaticamente baseado no tipo.

**3. Adicionar `case "premiacao"` no destination de String**

```swift
.navigationDestination(for: String.self) { rota in
    switch rota {
    case "ilha": IlhaView()
    case "floresta": FlorestaView()
    case "rio": RioView()
    case "criatura": CriaturaView()
    case "premiacao": PremiacaoView()  // ← adicionar
    default: EmptyView()
    }
}
```

**4. Na BauView, trocar o Button "Usar Chave" por NavigationLink**

```swift
NavigationLink(value: "premiacao") {
    Text("Usar Chave & Abrir")
}
.disabled(!baú.temChave)
```

**Por que `.disabled(!baú.temChave)`:** se o baú não tem chave, o link fica desabilitado (cinza, não clicável). Isso é **navegação condicional**: o link existe, mas só funciona se a condição for verdadeira.

**5. Na PremiacaoView, implementar o botão "Comemorar e Fechar"**

```swift
Button {
    router.popToRoot()  // ou path = NavigationPath()
} label: {
    Text("Comemorar e Fechar")
}
```

Pop to root. O usuário volta pra ContentView, pronto pra jogar de novo.

### O fluxo completo do path

Assumindo que o jogador enfrenta o urso e ganha:

```
1. Início:          path = []
2. Iniciar Jornada: path = ["ilha"]
3. Entrar Floresta: path = ["ilha", "floresta"]
4. Seguir Rio:      path = ["ilha", "floresta", "rio"]
5. Entrar Caverna:  path = ["ilha", "floresta", "rio", "criatura"]
6. Enfrentar Urso:  path = ["ilha", "floresta", "rio", "criatura", Baú(id:.., temChave:true)]
7. Usar Chave:      path = ["ilha", "floresta", "rio", "criatura", Baú(...), "premiacao"]
8. Comemorar:       path = []  ← pop to root
```

Note que no passo 7 o path tem **tipos misturados**: 4 Strings, 1 Baú, mais 1 String. Isso só é possível porque NavigationPath aceita qualquer Hashable. Um `[String]` não conseguiria.

### Como testar
Percorre o fluxo inteiro até a PremiacaoView e volta pro início. Depois, tenta jogar de novo — se o pop to root funcionou, o jogo reinicia sem app fechar.

---

## Referência Rápida

Quando precisar consultar depois do workshop:

| Preciso... | Uso |
|---|---|
| Criar contêiner de navegação | `NavigationStack(path: $path) { }` |
| Empilhar por toque simples | `NavigationLink(value: X) { label }` |
| Empilhar por código | `path.append(X)` ou `router.push(X)` |
| Voltar 1 tela por código | `path.removeLast()` ou `router.pop()` |
| Voltar 1 tela simples | `@Environment(\.dismiss)` + `dismiss()` |
| Voltar N telas | `path.removeLast(N)` |
| Voltar ao início | `path = NavigationPath()` ou `router.popToRoot()` |
| Registrar rota | `.navigationDestination(for: X.self) { }` |
| Esconder botão voltar | `.navigationBarBackButtonHidden(true)` |
| Empilhar struct customizada | Struct precisa de `: Hashable` |
| Passar dados pra próxima tela | Struct Hashable com propriedades |
| Compartilhar path | Router + `@EnvironmentObject` |

---

Boa jornada, marujo! 🏴‍☠️
