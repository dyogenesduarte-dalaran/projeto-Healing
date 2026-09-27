# Decisões de Arquitetura — Por que usar Spring Boot e Flyway no Projeto Healing?

## Contexto

O Projeto Healing é um projeto de dados e análise de vendas construído sobre PostgreSQL. Tecnicamente, seria possível criar todas as tabelas, inserir dados e executar análises diretamente pelo pgAdmin, sem utilizar Java ou Spring Boot.

Da mesma forma, também seria possível utilizar o Hibernate para criar ou alterar automaticamente a estrutura do banco.

Mesmo assim, o projeto utiliza **Spring Boot** e **Flyway** de forma intencional. A decisão não foi tomada porque essas ferramentas sejam obrigatórias, mas porque cada uma resolve um problema diferente e aproxima o projeto de um cenário profissional real.

## 1. Poderíamos fazer tudo diretamente no pgAdmin?

Sim.

O pgAdmin é suficiente para criar banco, schemas e tabelas; executar `CREATE`, `ALTER`, `INSERT`, `UPDATE` e `DELETE`; criar índices e constraints; executar consultas analíticas; validar dados; e administrar o PostgreSQL.

Para um projeto exclusivamente voltado à prática de SQL ou análise de dados, trabalhar apenas com PostgreSQL e pgAdmin seria totalmente válido.

O problema aparece quando queremos que o banco faça parte de uma **aplicação versionada e reproduzível**.

Se toda alteração for feita manualmente no pgAdmin, o banco pode funcionar perfeitamente na minha máquina, mas outra pessoa que clonar o projeto não terá necessariamente o mesmo histórico de criação e evolução do schema.

Por isso, no Healing, o pgAdmin é utilizado como ferramenta de administração e inspeção, enquanto a evolução oficial da estrutura do banco fica registrada no código do projeto.

## 2. Então por que utilizar Java e Spring Boot?

O Spring Boot representa a **camada de aplicação**.

O PostgreSQL armazena e protege os dados. O Spring Boot pode ser responsável por receber requisições, aplicar regras de negócio, validar informações, consultar o banco e disponibilizar dados para outras aplicações.

Uma arquitetura simplificada poderia ser representada assim:

```text
Cliente / Front-end / Power BI / Integração
                 |
                 v
            Spring Boot
                 |
          Regras de negócio
                 |
                 v
            PostgreSQL
```

No estágio atual do Healing, nem todas essas funcionalidades precisam estar implementadas. A presença do Spring Boot também tem um objetivo arquitetural e de portfólio: mostrar que o banco não está sendo tratado como um conjunto isolado de tabelas, mas como parte de um sistema.

### Exemplo

Imagine uma regra futura:

> Um pagamento pode receber no máximo duas tentativas consecutivas. Se ambas forem negadas, uma nova tentativa somente poderá ocorrer após 10 minutos.

O PostgreSQL pode armazenar as tentativas e também pode possuir algumas regras de integridade.

Mas uma aplicação Spring Boot poderia controlar o fluxo:

```text
requisição de pagamento
        |
        v
consulta tentativas anteriores
        |
        v
aplica regra de negócio
        |
   +----+----+
   |         |
permitir    bloquear
   |
   v
registrar tentativa
```

Isso mostra a separação entre **persistência de dados** e **comportamento da aplicação**.

## 3. Spring Boot é necessário para um projeto de análise de dados?

Não necessariamente.

Se o objetivo do projeto fosse exclusivamente SQL, análise exploratória, Power BI, dashboards e métricas, seria perfeitamente possível utilizar apenas PostgreSQL, pgAdmin e ferramentas de análise.

No Healing, porém, Java/Spring Boot é complementar ao foco principal em Dados.

A intenção é demonstrar que eu consigo compreender não somente como consultar os dados, mas também como eles podem nascer, ser validados, armazenados e consumidos por uma aplicação.

Isso cria uma integração entre:

```text
Backend
   +
Banco de Dados
   +
Análise de Dados
```

## 4. Poderíamos usar Hibernate para criar as tabelas?

Sim.

O Hibernate, através do JPA, consegue gerar ou atualizar a estrutura do banco a partir das entidades Java.

Por exemplo:

```java
@Entity
public class Cliente {

    @Id
    @GeneratedValue
    private Long id;

    private String nome;

    private String email;
}
```

Dependendo da configuração da aplicação, o Hibernate pode transformar essa entidade em uma tabela no banco.

Configurações conhecidas incluem:

```properties
spring.jpa.hibernate.ddl-auto=create
```

ou:

```properties
spring.jpa.hibernate.ddl-auto=update
```

Isso é conveniente durante protótipos e experimentos.

Entretanto, existe uma diferença importante entre **gerar o schema atual** e **controlar a evolução histórica do banco**.

## 5. Então por que utilizar Flyway?

O Flyway é utilizado para **versionar as mudanças do banco de dados**.

No Healing, temos migrations como:

```text
V1__create_cliente_categoria.sql
V2__create_produto.sql
V3__create_pedido.sql
...
V14__generate_pedidos_sinteticos.sql
V15__generate_itens_pedido.sql
V16__recalcular_totais_pedido.sql
```

Isso cria uma linha histórica da evolução do banco:

```text
V1
 |
V2
 |
V3
 |
...
 |
V16
```

Cada migration representa uma mudança conhecida e controlada.

Quando a aplicação inicia, o Flyway verifica quais migrations já foram executadas e aplica apenas as que ainda faltam.

Com isso, outra pessoa pode clonar o projeto, criar um banco vazio e executar as migrations para chegar à mesma estrutura.

Isso aumenta a **reprodutibilidade** do projeto.

## 6. Hibernate e Flyway fazem a mesma coisa?

Não.

Eles podem tocar em partes semelhantes do banco, mas possuem responsabilidades diferentes.

| Tecnologia | Responsabilidade principal |
|---|---|
| PostgreSQL | Armazenar, consultar e garantir integridade dos dados |
| pgAdmin | Administrar e inspecionar o PostgreSQL |
| Hibernate / JPA | Mapear objetos Java para tabelas relacionais |
| Flyway | Versionar e aplicar mudanças estruturais no banco |
| Spring Boot | Organizar e executar a aplicação e suas regras |

Uma forma simples de explicar:

> **Hibernate entende como o objeto Java se relaciona com o banco. Flyway registra como o banco evoluiu ao longo do tempo.**

## 7. Por que não deixar o Hibernate atualizar o banco automaticamente?

Porque em ambientes profissionais queremos mudanças de banco **explícitas, revisáveis e previsíveis**.

Suponha que uma coluna precise ser adicionada:

```sql
ALTER TABLE cliente
ADD COLUMN telefone VARCHAR(20);
```

Com Flyway, podemos criar:

```text
V17__add_telefone_cliente.sql
```

Agora sabemos exatamente o que mudou, em qual versão e qual SQL foi executado.

Se dependermos apenas de geração automática do Hibernate, parte desse histórico pode ficar implícita na configuração e no estado atual das entidades.

Por esse motivo, em um projeto com migrations, uma prática comum é deixar o Flyway responsável pela evolução do schema e utilizar o Hibernate principalmente para o mapeamento das entidades.

Uma configuração possível é:

```properties
spring.jpa.hibernate.ddl-auto=validate
```

Nesse caso, o Hibernate não tenta criar o banco. Ele verifica se o modelo Java é compatível com o schema existente.

A ideia fica assim:

```text
Flyway
   |
   v
cria/evolui schema
   |
   v
PostgreSQL
   ^
   |
Hibernate valida/mapeia
   ^
   |
Spring Boot
```

## 8. O erro que ocorreu no Healing mostrou uma vantagem real

Durante a geração dos dados sintéticos, uma migration tentou produzir um valor de pedido inconsistente.

A constraint do PostgreSQL bloqueou o registro e a migration não foi concluída.

Após corrigirmos a regra, ela pôde ser executada novamente corretamente.

Esse episódio demonstra três responsabilidades diferentes trabalhando juntas:

```text
Flyway
controla execução e versionamento

PostgreSQL
protege a integridade

Spring Boot
inicializa e integra o processo
```

Isso é mais próximo de um cenário profissional do que simplesmente executar scripts isolados manualmente.

## 9. Como responder isso em uma entrevista?

### “Você precisava de Spring Boot para fazer esse projeto?”

> Não. Eu poderia ter construído toda a estrutura e realizado as análises diretamente no PostgreSQL através do pgAdmin. Eu optei por manter o Spring Boot porque queria tratar o banco como parte de uma aplicação real, e não apenas como um conjunto isolado de tabelas. O foco do projeto continua sendo Dados e SQL, mas o Spring Boot me permite demonstrar como esse banco poderia ser integrado a uma camada de aplicação e a regras de negócio.

### “Por que Flyway se o Hibernate consegue criar as tabelas?”

> Porque eu separei as responsabilidades. O Hibernate é utilizado para o mapeamento objeto-relacional entre Java e PostgreSQL. Já o Flyway é responsável pela evolução versionada do schema. Com migrations eu consigo saber exatamente como o banco evoluiu, reproduzir a estrutura em outro ambiente e manter as alterações registradas no Git. Eu prefiro que mudanças estruturais importantes sejam explícitas em SQL em vez de depender apenas da geração automática do Hibernate.

### “Por que não executar os scripts manualmente no pgAdmin?”

> Eu uso o pgAdmin para administração, inspeção e consultas, mas não como fonte oficial da evolução do banco. Se eu alterar tudo manualmente, essas mudanças ficam dependentes do meu ambiente local. Colocando as migrations no projeto, a estrutura passa a ser versionada junto com o código e pode ser reproduzida por outra pessoa.

### “Então Hibernate e Flyway são concorrentes?”

> Não necessariamente. Eles resolvem problemas diferentes e podem trabalhar juntos. O Flyway controla a estrutura e as versões do banco, enquanto o Hibernate faz o mapeamento entre as entidades Java e as tabelas. Em uma configuração mais controlada, o Flyway cria e altera o schema e o Hibernate apenas valida e utiliza essa estrutura.

## 10. Decisão adotada no Projeto Healing

```text
PostgreSQL
→ banco principal

pgAdmin
→ administração, inspeção e execução de consultas

Flyway
→ criação, versionamento e evolução controlada do schema

Spring Boot
→ camada de aplicação e integração

Hibernate/JPA
→ mapeamento objeto-relacional quando a aplicação utilizar entidades
```

Essa arquitetura não é a única forma possível de construir o projeto.

Ela foi escolhida porque permite estudar e demonstrar competências complementares sem perder o foco principal do Healing: **modelagem, SQL, PostgreSQL e análise de dados**.

## Conclusão

A principal decisão não foi usar mais tecnologia por usar.

Foi separar responsabilidades.

```text
PostgreSQL cuida dos dados.

Flyway cuida da história do banco.

Hibernate cuida do mapeamento entre objetos e tabelas.

Spring Boot cuida da aplicação.

pgAdmin ajuda a administrar e investigar o banco.
```

Essa separação torna o projeto mais organizado, reproduzível e próximo de práticas encontradas em aplicações reais.
