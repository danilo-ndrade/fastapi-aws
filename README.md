# 🎓 API em Python com deploy utilizando GitHub Actions e infraestrutura com Terraform na AWS.

[![CI/CD AWS Deploy](https://github.com/danilo-santos/fastapi-aws/actions/workflows/pipeline.yaml/badge.svg)](https://github.com/danilo-santos/fastapi-aws/actions/workflows/pipeline.yaml)
[![Python](https://img.shields.io/badge/python-3.12-blue.svg)](https://python.org)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.115.12-009688.svg)](https://fastapi.tiangolo.com)
[![AWS](https://img.shields.io/badge/AWS-Cloud-orange.svg)](https://aws.amazon.com)

O código da API feita com FastAPI é um fork de um projeto utilizado durante a Imersão DevOps. Na ocasião foi utilizada a nuvem Google Cloud. Neste projeto reutilizo apenas o código da API para fazer o mesmo procedimento na AWS, além de automatizar o provisionamento da infraestrutura com Terraform.

### 🎯 Objetivos de Aprendizado

- [x] Containerização com **Docker**
- [x] Deploy na **AWS** (EC2, ECR, IAM)
- [x] Infraestrutura como Código com **Terraform**
- [x] CI/CD com **GitHub Actions**
- [x] Autenticação OIDC para AWS
- [x] Automação de deploy com **Docker Compose**

## 🏗️ Arquitetura

![alt text](https://github.com/danilo-ndrade/fastapi-aws/blob/main/architecture.png "Logo Title Text 1")

### 🔧 Stack Tecnológica

**Backend:**

- **FastAPI** - Framework web moderno e rápido
- **SQLAlchemy** - ORM para banco de dados
- **SQLite** - Banco de dados (para simplicidade do estudo)
- **Pydantic** - Validação de dados

**DevOps:**

- **Docker** - Containerização
- **AWS ECR** - Registry de containers
- **AWS EC2** - Hosting da aplicação
- **Terraform** - Infrastructure as Code
- **GitHub Actions** - CI/CD pipeline

## 🚀 Funcionalidades

### API Endpoints

#### 👨‍🎓 Alunos

- `GET /alunos/` - Listar todos os alunos
- `POST /alunos/` - Criar novo aluno
- `GET /alunos/{id}` - Buscar aluno por ID
- `PUT /alunos/{id}` - Atualizar aluno
- `DELETE /alunos/{id}` - Remover aluno

#### 📚 Cursos

- `GET /cursos/` - Listar todos os cursos
- `POST /cursos/` - Criar novo curso
- `GET /cursos/{id}` - Buscar curso por ID
- `PUT /cursos/{id}` - Atualizar curso
- `DELETE /cursos/{id}` - Remover curso

#### 📝 Matrículas

- `GET /matriculas/` - Listar todas as matrículas
- `POST /matriculas/` - Criar nova matrícula
- `GET /matriculas/{id}` - Buscar matrícula por ID
- `DELETE /matriculas/{id}` - Remover matrícula

## 🛠️ Instalação e Execução

### Pré-requisitos

- Terraform (para provisionar infraestrutura)

## ☁️ Deploy na AWS

O deploy na AWS é dividido em 4 etapas principais: provisionamento da infraestrutura, configuração da autenticação segura entre GitHub e AWS, configuração dos segredos no repositório e, finalmente, o deploy automático via push.

### 🏗️ 1. Configuração da Infraestrutura (Terraform)

Primeiro, provisione todos os recursos necessários na AWS executando os comandos do Terraform.

```bash
cd terraform/
terraform init
terraform plan
terraform apply
```

**Recursos criados:**

- VPC com subnet pública
- Security Group configurado
- Instância EC2 com Docker
- ECR Repository
- IAM Roles e Policies
- Internet Gateway e Route Table

### 🔐 2. Configuração da Autenticação OIDC

Para que o GitHub Actions possa se comunicar com a AWS de forma segura, sem usar chaves de acesso de longa duração, configuramos uma relação de confiança via OpenID Connect (OIDC). Esta é uma configuração única na sua conta AWS.

### 2.1. Criar o Provedor de Identidade (Identity Provider)

No console da AWS, vá para IAM > Provedores de identidade e adicione um novo provedor com as seguintes informações:

  - Tipo de provedor: OpenID Connect
  - URL do provedor: https://token.actions.githubusercontent.com
  - Público (Audience): sts.amazonaws.com

### 2.2. Criar a Role (Função) para o GitHub Actions

Crie uma nova Role no IAM que será "assumida" pelo GitHub Actions para obter permissões temporárias. Vá em IAM > Roles > Create role: 
  
  - Em Trusted entity type selecione 'Web Identity'
  - Identity provider: **https://token.actions.githubusercontent.com**
  - Audience: sts.amazonaws.com
  - GitHUb organizations: sua organização ou sua conta do github
  - GitHub repository: nome do seu repositório(é opcional mas recomendado)
  - Github branch: main

### 🔑 3. Configuração dos Secrets no GitHub

Configure os seguintes secrets no seu repositório GitHub:

```
AWS_REGION= sa-east-1 (ou a região da sua preferência)
AWS_ACCOUNT_ID= ID da sua conta AWS
AWS_ROLE_TO_ASSUME= o ARN da role criada para o GitHubActions
ECR_REPOSITORY= Nome do repositório do ECR 
EC2_HOST= IP Público da instância
EC2_USERNAME= ec2-user
SSH_PRIVATE_KEY= Key privada para acesso a instância
```

### 🚀 4. Deploy Automático

O deploy é automatizado via GitHub Actions:

1. **Push para branch `main`** dispara o pipeline
2. **Build** da imagem Docker
3. **Push** para AWS ECR
4. **Deploy** na instância EC2
5. **Atualização** automática do container

## 📊 Pipeline CI/CD

O pipeline automatizado realiza:

```yaml
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Build     │───▶│   Push      │───▶│   Deploy    │
│   • Docker  │    │   • ECR     │    │   • EC2     │
│   • Test    │    │   • Tag     │    │   • Update  │
└─────────────┘    └─────────────┘    └─────────────┘
```

**Recursos do Pipeline:**

- ✅ Build automático da imagem Docker
- ✅ Push para AWS ECR com tag `latest`
- ✅ Deploy automático na EC2
- ✅ Autenticação OIDC (sem chaves AWS hardcoded)
- ✅ Cleanup de imagens antigas
- ✅ Zero-downtime deployment

## 📁 Estrutura do Projeto

```
fastapi-aws/
├── 📁 .github/workflows/
│   └── pipeline.yaml          # CI/CD Pipeline
├── 📁 routers/
│   ├── alunos.py             # Endpoints de alunos
│   ├── cursos.py             # Endpoints de cursos
│   └── matriculas.py         # Endpoints de matrículas
├── 📁 terraform/
│   ├── main.tf               # Recursos AWS
│   ├── variables.tf          # Variáveis
│   └── outputs.tf            # Outputs
├── app.py                    # Aplicação principal
├── database.py               # Configuração do banco
├── models.py                 # Modelos SQLAlchemy
├── schemas.py                # Esquemas Pydantic
├── Dockerfile                # Container definition
├── docker-compose.yaml       # Orquestração local
├── requirements.txt          # Dependências Python
└── README.md                 # Este arquivo
```

## 🔒 Segurança

- **OIDC Authentication** para AWS (sem chaves de acesso hardcoded)
- **IAM Roles** com princípio de menor privilégio
- **Security Groups** configurados adequadamente
- **Container isolation** com Docker

## 👨‍💻 Autor

**Danilo Santos**

- GitHub: [@danilo-ndrade](https://github.com/danilo-ndrade)
- LinkedIn: [Danilo Andrade](https://www.linkedin.com/in/danilo-andrade-santos/)
