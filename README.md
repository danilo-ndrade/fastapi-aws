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

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   GitHub        │    │   AWS ECR       │    │   AWS EC2       │
│   Actions       │───▶│   Container     │───▶│   FastAPI       │
│   (CI/CD)       │    │   Registry      │    │   Application   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                                              │
         │              ┌─────────────────┐             │
         └─────────────▶│   Terraform     │◀────────────┘
                        │   (IaC)         │
                        └─────────────────┘
```

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

### 🏗️ 1. Configuração da Infraestrutura (Terraform)

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

### 🔐 2. Configuração dos Secrets no GitHub

Configure os seguintes secrets no seu repositório GitHub:

```
AWS_REGION=us-east-1
AWS_ACCOUNT_ID=123456789012
AWS_ROLE_TO_ASSUME=arn:aws:iam::123456789012:role/GitHubActionsRole
ECR_REPOSITORY=fastapi-aws-app
EC2_HOST=ec2-x-x-x-x.compute-1.amazonaws.com
EC2_USERNAME=ubuntu
SSH_PRIVATE_KEY=-----BEGIN RSA PRIVATE KEY-----...
```

### 🚀 3. Deploy Automático

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

## 🤝 Contribuindo

Este é um projeto de estudo, mas contribuições são bem-vindas:

1. Fork o projeto
2. Crie sua feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 👨‍💻 Autor

**Danilo Santos**

- GitHub: [@danilo-santos](https://github.com/danilo-ndrade)
- LinkedIn: [Danilo Andrade](https://www.linkedin.com/in/danilo-andrade-santos/)
