from datetime import datetime, timedelta
from enum import Enum
from typing import Optional

from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from pydantic import BaseModel, EmailStr
from jose import jwt, JWTError
from passlib.context import CryptContext
from sqlalchemy import (
    create_engine,
    Column,
    Integer,
    String,
    DateTime,
    ForeignKey,
    Text,
)
from sqlalchemy.orm import declarative_base, sessionmaker, Session, relationship


# ============================================================
# CONFIGURAÇÕES
# ============================================================

DATABASE_URL = "sqlite:///./patrimonio.db"

SECRET_KEY = "troque_esta_chave_por_uma_chave_segura"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60 * 24

engine = create_engine(
    DATABASE_URL,
    connect_args={"check_same_thread": False},
)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine,
)

Base = declarative_base()

pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto",
)

oauth2_scheme = OAuth2PasswordBearer(
    tokenUrl="/api/auth/login"
)


# ============================================================
# ENUMS
# ============================================================

class Role(str, Enum):
    ADMIN = "admin"
    PROFESSOR = "professor"


class StatusPatrimonio(str, Enum):
    DISPONIVEL = "disponivel"
    EM_USO = "em_uso"
    EM_MANUTENCAO = "em_manutencao"


# ============================================================
# MODELS
# ============================================================

class Usuario(Base):
    __tablename__ = "usuarios"

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String(150), nullable=False)
    email = Column(String(150), unique=True, nullable=False, index=True)
    senha_hash = Column(String(255), nullable=False)
    role = Column(String(30), nullable=False)
    telefone = Column(String(30), nullable=True)
    matricula = Column(String(50), nullable=True)
    departamento = Column(String(100), nullable=True)

    patrimonios = relationship(
        "Patrimonio",
        back_populates="professor",
    )


class Patrimonio(Base):
    __tablename__ = "patrimonios"

    id = Column(Integer, primary_key=True, index=True)
    tombamento = Column(String(100), unique=True, nullable=False)
    descricao = Column(String(255), nullable=False)
    categoria = Column(String(100), nullable=False)
    marca = Column(String(100), nullable=True)
    numero_serie = Column(String(100), nullable=True)
    localizacao = Column(String(150), nullable=True)
    status = Column(
        String(30),
        default=StatusPatrimonio.DISPONIVEL.value,
        nullable=False,
    )

    professor_id = Column(
        Integer,
        ForeignKey("usuarios.id"),
        nullable=True,
    )

    data_atribuicao = Column(
        DateTime,
        nullable=True,
    )

    professor = relationship(
        "Usuario",
        back_populates="patrimonios",
    )


class HistoricoPatrimonio(Base):
    __tablename__ = "historico_patrimonios"

    id = Column(Integer, primary_key=True, index=True)

    patrimonio_id = Column(
        Integer,
        ForeignKey("patrimonios.id"),
        nullable=False,
    )

    professor_id = Column(
        Integer,
        ForeignKey("usuarios.id"),
        nullable=True,
    )

    acao = Column(String(50), nullable=False)
    motivo = Column(Text, nullable=True)
    data = Column(DateTime, default=datetime.utcnow)


Base.metadata.create_all(bind=engine)


# ============================================================
# APP
# ============================================================

app = FastAPI(
    title="Sistema Integrado de Gestão de Patrimônio Escolar",
    description="API REST para gestão de patrimônio escolar",
    version="1.0.0",
)


# ============================================================
# BANCO
# ============================================================

def get_db():
    db = SessionLocal()

    try:
        yield db
    finally:
        db.close()


# ============================================================
# SEGURANÇA
# ============================================================

def hash_password(password: str) -> str:
    return pwd_context.hash(password)


def verify_password(
    password: str,
    password_hash: str,
) -> bool:
    return pwd_context.verify(
        password,
        password_hash,
    )


def create_access_token(
    data: dict,
    expires_delta: Optional[timedelta] = None,
):
    to_encode = data.copy()

    expire = datetime.utcnow() + (
        expires_delta
        or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    )

    to_encode.update(
        {
            "exp": expire,
        }
    )

    return jwt.encode(
        to_encode,
        SECRET_KEY,
        algorithm=ALGORITHM,
    )


def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db),
):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Token inválido ou expirado",
        headers={
            "WWW-Authenticate": "Bearer"
        },
    )

    try:
        payload = jwt.decode(
            token,
            SECRET_KEY,
            algorithms=[ALGORITHM],
        )

        user_id = payload.get("sub")

        if user_id is None:
            raise credentials_exception

    except JWTError:
        raise credentials_exception

    user = db.query(Usuario).filter(
        Usuario.id == int(user_id)
    ).first()

    if user is None:
        raise credentials_exception

    return user


def require_admin(
    current_user: Usuario = Depends(get_current_user),
):
    if current_user.role != Role.ADMIN.value:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Acesso permitido apenas para administradores",
        )

    return current_user


# ============================================================
# SCHEMAS
# ============================================================

class CadastroAdmin(BaseModel):
    nome: str
    email: EmailStr
    senha: str
    telefone: Optional[str] = None


class CadastroProfessor(BaseModel):
    nome: str
    email: EmailStr
    senha: str
    telefone: Optional[str] = None
    matricula: Optional[str] = None
    departamento: Optional[str] = None


class AtualizarPerfil(BaseModel):
    nome: Optional[str] = None
    telefone: Optional[str] = None


class AlterarSenha(BaseModel):
    senha_atual: str
    nova_senha: str


class PatrimonioCreate(BaseModel):
    tombamento: str
    descricao: str
    categoria: str
    marca: Optional[str] = None
    numero_serie: Optional[str] = None
    localizacao: Optional[str] = None
    status: StatusPatrimonio = StatusPatrimonio.DISPONIVEL


class PatrimonioUpdate(BaseModel):
    descricao: Optional[str] = None
    categoria: Optional[str] = None
    marca: Optional[str] = None
    numero_serie: Optional[str] = None
    localizacao: Optional[str] = None
    status: Optional[StatusPatrimonio] = None


class AtribuirPatrimonio(BaseModel):
    professor_id: int


class DevolverPatrimonio(BaseModel):
    motivo: Optional[str] = None


class RecuperarSenha(BaseModel):
    email: EmailStr


class ResetarSenha(BaseModel):
    email: EmailStr
    codigo: str
    nova_senha: str


# ============================================================
# ROTAS BÁSICAS
# ============================================================

@app.get("/")
def root():
    return {
        "message": "API de Patrimônio Escolar funcionando",
        "version": "1.0.0",
        "docs": "/docs",
    }


@app.get("/api/health")
def health():
    return {
        "status": "ok"
    }


# ============================================================
# AUTENTICAÇÃO
# ============================================================

@app.post("/api/auth/cadastro")
def cadastrar_admin(
    dados: CadastroAdmin,
    db: Session = Depends(get_db),
):
    existente = db.query(Usuario).filter(
        Usuario.email == dados.email
    ).first()

    if existente:
        raise HTTPException(
            status_code=400,
            detail="E-mail já cadastrado",
        )

    admin = Usuario(
        nome=dados.nome,
        email=dados.email,
        senha_hash=hash_password(dados.senha),
        role=Role.ADMIN.value,
        telefone=dados.telefone,
    )

    db.add(admin)
    db.commit()
    db.refresh(admin)

    return {
        "message": "Administrador cadastrado com sucesso",
        "id": admin.id,
        "role": admin.role,
    }


@app.post("/api/auth/login")
def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db),
):
    usuario = db.query(Usuario).filter(
        Usuario.email == form_data.username
    ).first()

    if not usuario:
        raise HTTPException(
            status_code=401,
            detail="E-mail ou senha inválidos",
        )

    if not verify_password(
        form_data.password,
        usuario.senha_hash,
    ):
        raise HTTPException(
            status_code=401,
            detail="E-mail ou senha inválidos",
        )

    token = create_access_token(
        {
            "sub": str(usuario.id),
            "role": usuario.role,
            "email": usuario.email,
        }
    )

    return {
        "access_token": token,
        "token_type": "bearer",
        "usuario": {
            "id": usuario.id,
            "nome": usuario.nome,
            "email": usuario.email,
            "role": usuario.role,
        },
    }


@app.post("/api/auth/recuperar-senha")
def recuperar_senha(
    dados: RecuperarSenha,
    db: Session = Depends(get_db),
):
    usuario = db.query(Usuario).filter(
        Usuario.email == dados.email
    ).first()

    if not usuario:
        return {
            "message": "Se o e-mail existir, um código será enviado"
        }

    # Em produção, aqui entraria o envio real do código.
    return {
        "message": "Código de recuperação solicitado"
    }


@app.post("/api/auth/resetar-senha")
def resetar_senha(
    dados: ResetarSenha,
    db: Session = Depends(get_db),
):
    usuario = db.query(Usuario).filter(
        Usuario.email == dados.email
    ).first()

    if not usuario:
        raise HTTPException(
            status_code=404,
            detail="Usuário não encontrado",
        )

    # Para o projeto escolar:
    if dados.codigo != "123456":
        raise HTTPException(
            status_code=400,
            detail="Código inválido",
        )

    usuario.senha_hash = hash_password(
        dados.nova_senha
    )

    db.commit()

    return {
        "message": "Senha alterada com sucesso"
    }


@app.post("/api/auth/logout")
def logout(
    current_user: Usuario = Depends(get_current_user),
):
    return {
        "message": "Logout realizado no cliente"
    }


# ============================================================
# USUÁRIO LOGADO
# ============================================================

@app.get("/api/me")
def get_me(
    current_user: Usuario = Depends(get_current_user),
):
    return {
        "id": current_user.id,
        "nome": current_user.nome,
        "email": current_user.email,
        "role": current_user.role,
        "telefone": current_user.telefone,
        "matricula": current_user.matricula,
        "departamento": current_user.departamento,
    }


@app.put("/api/me")
def atualizar_perfil(
    dados: AtualizarPerfil,
    current_user: Usuario = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    if dados.nome is not None:
        current_user.nome = dados.nome

    if dados.telefone is not None:
        current_user.telefone = dados.telefone

    db.commit()
    db.refresh(current_user)

    return {
        "message": "Perfil atualizado com sucesso"
    }


@app.put("/api/me/senha")
def alterar_senha(
    dados: AlterarSenha,
    current_user: Usuario = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    if not verify_password(
        dados.senha_atual,
        current_user.senha_hash,
    ):
        raise HTTPException(
            status_code=400,
            detail="Senha atual incorreta",
        )

    current_user.senha_hash = hash_password(
        dados.nova_senha
    )

    db.commit()

    return {
        "message": "Senha alterada com sucesso"
    }


# ============================================================
# PROFESSORES - ADMIN
# ============================================================

@app.post("/api/professores")
def cadastrar_professor(
    dados: CadastroProfessor,
    admin: Usuario = Depends(require_admin),
    db: Session = Depends(get_db),
):
    existente = db.query(Usuario).filter(
        Usuario.email == dados.email
    ).first()

    if existente:
        raise HTTPException(
            status_code=400,
            detail="E-mail já cadastrado",
        )

    professor = Usuario(
        nome=dados.nome,
        email=dados.email,
        senha_hash=hash_password(dados.senha),
        role=Role.PROFESSOR.value,
        telefone=dados.telefone,
        matricula=dados.matricula,
        departamento=dados.departamento,
    )

    db.add(professor)
    db.commit()
    db.refresh(professor)

    return {
        "message": "Professor cadastrado com sucesso",
        "id": professor.id,
    }


@app.get("/api/professores")
def listar_professores(
    admin: Usuario = Depends(require_admin),
    db: Session = Depends(get_db),
):
    professores = db.query(Usuario).filter(
        Usuario.role == Role.PROFESSOR.value
    ).all()

    resultado = []

    for professor in professores:
        quantidade = db.query(Patrimonio).filter(
            Patrimonio.professor_id == professor.id
        ).count()

        resultado.append(
            {
                "id": professor.id,
                "nome": professor.nome,
                "email": professor.email,
                "telefone": professor.telefone,
                "matricula": professor.matricula,
                "departamento": professor.departamento,
                "quantidade_patrimonios": quantidade,
            }
        )

    return resultado


@app.get("/api/professores/{professor_id}")
def detalhes_professor(
    professor_id: int,
    admin: Usuario = Depends(require_admin),
    db: Session = Depends(get_db),
):
    professor = db.query(Usuario).filter(
        Usuario.id == professor_id,
        Usuario.role == Role.PROFESSOR.value,
    ).first()

    if not professor:
        raise HTTPException(
            status_code=404,
            detail="Professor não encontrado",
        )

    patrimonios = db.query(Patrimonio).filter(
        Patrimonio.professor_id == professor.id
    ).all()

    return {
        "id": professor.id,
        "nome": professor.nome,
        "email": professor.email,
        "telefone": professor.telefone,
        "matricula": professor.matricula,
        "departamento": professor.departamento,
        "patrimonios": [
            {
                "id": p.id,
                "tombamento": p.tombamento,
                "descricao": p.descricao,
                "categoria": p.categoria,
                "status": p.status,
                "localizacao": p.localizacao,
                "data_atribuicao": p.data_atribuicao,
            }
            for p in patrimonios
        ],
    }


# ============================================================
# PATRIMÔNIOS
# ============================================================

@app.post("/api/patrimonios")
def criar_patrimonio(
    dados: PatrimonioCreate,
    admin: Usuario = Depends(require_admin),
    db: Session = Depends(get_db),
):
    existente = db.query(Patrimonio).filter(
        Patrimonio.tombamento == dados.tombamento
    ).first()

    if existente:
        raise HTTPException(
            status_code=400,
            detail="Tombamento já cadastrado",
        )

    patrimonio = Patrimonio(
        tombamento=dados.tombamento,
        descricao=dados.descricao,
        categoria=dados.categoria,
        marca=dados.marca,
        numero_serie=dados.numero_serie,
        localizacao=dados.localizacao,
        status=dados.status.value,
    )

    db.add(patrimonio)
    db.commit()
    db.refresh(patrimonio)

    return patrimonio


@app.get("/api/patrimonios")
def listar_patrimonios(
    status_filtro: Optional[StatusPatrimonio] = None,
    categoria: Optional[str] = None,
    busca: Optional[str] = None,
    current_user: Usuario = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    query = db.query(Patrimonio)

    if current_user.role == Role.PROFESSOR.value:
        query = query.filter(
            Patrimonio.professor_id == current_user.id
        )

    if status_filtro:
        query = query.filter(
            Patrimonio.status == status_filtro.value
        )

    if categoria:
        query = query.filter(
            Patrimonio.categoria == categoria
        )

    if busca:
        termo = f"%{busca}%"

        query = query.filter(
            (Patrimonio.tombamento.ilike(termo))
            | (Patrimonio.descricao.ilike(termo))
            | (Patrimonio.marca.ilike(termo))
        )

    patrimonios = query.all()

    return [
        {
            "id": patrimonio.id,
            "tombamento": patrimonio.tombamento,
            "descricao": patrimonio.descricao,
            "categoria": patrimonio.categoria,
            "marca": patrimonio.marca,
            "numero_serie": patrimonio.numero_serie,
            "localizacao": patrimonio.localizacao,
            "status": patrimonio.status,
            "professor_id": patrimonio.professor_id,
            "data_atribuicao": patrimonio.data_atribuicao,
        }
        for patrimonio in patrimonios
    ]


@app.get("/api/patrimonios/{patrimonio_id}")
def detalhes_patrimonio(
    patrimonio_id: int,
    current_user: Usuario = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    patrimonio = db.query(Patrimonio).filter(
        Patrimonio.id == patrimonio_id
    ).first()

    if not patrimonio:
        raise HTTPException(
            status_code=404,
            detail="Patrimônio não encontrado",
        )

    if (
        current_user.role == Role.PROFESSOR.value
        and patrimonio.professor_id != current_user.id
    ):
        raise HTTPException(
            status_code=403,
            detail="Você não possui acesso a este patrimônio",
        )

    return {
        "id": patrimonio.id,
        "tombamento": patrimonio.tombamento,
        "descricao": patrimonio.descricao,
        "categoria": patrimonio.categoria,
        "marca": patrimonio.marca,
        "numero_serie": patrimonio.numero_serie,
        "localizacao": patrimonio.localizacao,
        "status": patrimonio.status,
        "professor_id": patrimonio.professor_id,
        "data_atribuicao": patrimonio.data_atribuicao,
    }


@app.put("/api/patrimonios/{patrimonio_id}")
def atualizar_patrimonio(
    patrimonio_id: int,
    dados: PatrimonioUpdate,
    admin: Usuario = Depends(require_admin),
    db: Session = Depends(get_db),
):
    patrimonio = db.query(Patrimonio).filter(
        Patrimonio.id == patrimonio_id
    ).first()

    if not patrimonio:
        raise HTTPException(
            status_code=404,
            detail="Patrimônio não encontrado",
        )

    if dados.descricao is not None:
        patrimonio.descricao = dados.descricao

    if dados.categoria is not None:
        patrimonio.categoria = dados.categoria

    if dados.marca is not None:
        patrimonio.marca = dados.marca

    if dados.numero_serie is not None:
        patrimonio.numero_serie = dados.numero_serie

    if dados.localizacao is not None:
        patrimonio.localizacao = dados.localizacao

    if dados.status is not None:
        patrimonio.status = dados.status.value

    db.commit()
    db.refresh(patrimonio)

    return {
        "message": "Patrimônio atualizado com sucesso"
    }


@app.delete("/api/patrimonios/{patrimonio_id}")
def excluir_patrimonio(
    patrimonio_id: int,
    admin: Usuario = Depends(require_admin),
    db: Session = Depends(get_db),
):
    patrimonio = db.query(Patrimonio).filter(
        Patrimonio.id == patrimonio_id
    ).first()

    if not patrimonio:
        raise HTTPException(
            status_code=404,
            detail="Patrimônio não encontrado",
        )

    if patrimonio.professor_id is not None:
        raise HTTPException(
            status_code=400,
            detail="Não é possível excluir patrimônio atribuído",
        )

    db.delete(patrimonio)
    db.commit()

    return {
        "message": "Patrimônio excluído com sucesso"
    }


# ============================================================
# ATRIBUIÇÃO
# ============================================================

@app.post(
    "/api/patrimonios/{patrimonio_id}/atribuir"
)
def atribuir_patrimonio(
    patrimonio_id: int,
    dados: AtribuirPatrimonio,
    admin: Usuario = Depends(require_admin),
    db: Session = Depends(get_db),
):
    patrimonio = db.query(Patrimonio).filter(
        Patrimonio.id == patrimonio_id
    ).first()

    if not patrimonio:
        raise HTTPException(
            status_code=404,
            detail="Patrimônio não encontrado",
        )

    professor = db.query(Usuario).filter(
        Usuario.id == dados.professor_id,
        Usuario.role == Role.PROFESSOR.value,
    ).first()

    if not professor:
        raise HTTPException(
            status_code=404,
            detail="Professor não encontrado",
        )

    if patrimonio.status != StatusPatrimonio.DISPONIVEL.value:
        raise HTTPException(
            status_code=400,
            detail="Patrimônio não está disponível",
        )

    patrimonio.professor_id = professor.id
    patrimonio.status = StatusPatrimonio.EM_USO.value
    patrimonio.data_atribuicao = datetime.utcnow()

    historico = HistoricoPatrimonio(
        patrimonio_id=patrimonio.id,
        professor_id=professor.id,
        acao="atribuicao",
        motivo="Patrimônio atribuído ao professor",
    )

    db.add(historico)
    db.commit()

    return {
        "message": "Patrimônio atribuído com sucesso"
    }


# ============================================================
# DEVOLUÇÃO
# ============================================================

@app.post(
    "/api/patrimonios/{patrimonio_id}/devolver"
)
def devolver_patrimonio(
    patrimonio_id: int,
    dados: DevolverPatrimonio,
    admin: Usuario = Depends(require_admin),
    db: Session = Depends(get_db),
):
    patrimonio = db.query(Patrimonio).filter(
        Patrimonio.id == patrimonio_id
    ).first()

    if not patrimonio:
        raise HTTPException(
            status_code=404,
            detail="Patrimônio não encontrado",
        )

    if patrimonio.professor_id is None:
        raise HTTPException(
            status_code=400,
            detail="Patrimônio não está atribuído",
        )

    professor_id = patrimonio.professor_id

    historico = HistoricoPatrimonio(
        patrimonio_id=patrimonio.id,
        professor_id=professor_id,
        acao="devolucao",
        motivo=dados.motivo,
    )

    patrimonio.professor_id = None
    patrimonio.status = StatusPatrimonio.DISPONIVEL.value
    patrimonio.data_atribuicao = None

    db.add(historico)
    db.commit()

    return {
        "message": "Patrimônio devolvido com sucesso"
    }


# ============================================================
# HISTÓRICO
# ============================================================

@app.get(
    "/api/patrimonios/{patrimonio_id}/historico"
)
def historico_patrimonio(
    patrimonio_id: int,
    current_user: Usuario = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    patrimonio = db.query(Patrimonio).filter(
        Patrimonio.id == patrimonio_id
    ).first()

    if not patrimonio:
        raise HTTPException(
            status_code=404,
            detail="Patrimônio não encontrado",
        )

    if (
        current_user.role == Role.PROFESSOR.value
        and patrimonio.professor_id != current_user.id
    ):
        raise HTTPException(
            status_code=403,
            detail="Acesso negado",
        )

    historico = db.query(
        HistoricoPatrimonio
    ).filter(
        HistoricoPatrimonio.patrimonio_id == patrimonio_id
    ).order_by(
        HistoricoPatrimonio.data.desc()
    ).all()

    return [
        {
            "id": item.id,
            "acao": item.acao,
            "professor_id": item.professor_id,
            "motivo": item.motivo,
            "data": item.data,
        }
        for item in historico
    ]


# ============================================================
# DASHBOARD
# ============================================================

@app.get("/api/dashboard")
def dashboard(
    admin: Usuario = Depends(require_admin),
    db: Session = Depends(get_db),
):
    total = db.query(Patrimonio).count()

    disponiveis = db.query(Patrimonio).filter(
        Patrimonio.status
        == StatusPatrimonio.DISPONIVEL.value
    ).count()

    em_uso = db.query(Patrimonio).filter(
        Patrimonio.status
        == StatusPatrimonio.EM_USO.value
    ).count()

    manutencao = db.query(Patrimonio).filter(
        Patrimonio.status
        == StatusPatrimonio.EM_MANUTENCAO.value
    ).count()

    patrimonios = db.query(Patrimonio).all()

    categorias = {}

    for patrimonio in patrimonios:
        categorias[patrimonio.categoria] = (
            categorias.get(patrimonio.categoria, 0) + 1
        )

    return {
        "total_bens": total,
        "disponiveis": disponiveis,
        "em_uso": em_uso,
        "em_manutencao": manutencao,
        "categorias": categorias,
    }


# ============================================================
# EXECUÇÃO
# ============================================================

if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8081,
        reload=True,
    )