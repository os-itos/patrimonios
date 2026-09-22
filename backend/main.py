from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional

app = FastAPI(title="API de Patrimônios SENAI")

# Habilita o CORS para aceitar requisições do Flutter Web / App
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Modelo de entrada (sem ID, usado no POST e PUT)
class PatrimonioBase(BaseModel):
    nome: str
    descricao: str
    local: str
    responsavel: str

# Modelo de saída (com ID)
class Patrimonio(PatrimonioBase):
    id: int

# Banco de dados em memória inicial
patrimonios_db = [
    Patrimonio(id=1, nome="Notebook", descricao="Notebook Dell Inspiron", local="C09", responsavel="João Silva"),
    Patrimonio(id=2, nome="Projetor", descricao="Projetor Epson", local="B08", responsavel="Maria Souza"),
    Patrimonio(id=3, nome="Cadeira", descricao="Cadeira de escritório", local="D01", responsavel="Carlos Oliveira"),
]
next_id = 4

@app.get("/patrimonios", response_model=List[Patrimonio], status_code=status.HTTP_200_OK)
def listar_patrimonios():
    return patrimonios_db

@app.get("/patrimonios/{id}", response_model=Patrimonio, status_code=status.HTTP_200_OK)
def buscar_patrimonio(id: int):
    for p in patrimonios_db:
        if p.id == id:
            return p
    raise HTTPException(status_code=404, detail="Patrimônio não encontrado")

@app.post("/patrimonios", response_model=Patrimonio, status_code=status.HTTP_201_CREATED)
def cadastrar_patrimonio(patrimonio: PatrimonioBase):
    global next_id
    novo_patrimonio = Patrimonio(id=next_id, **patrimonio.model_dump())
    patrimonios_db.append(novo_patrimonio)
    next_id += 1
    return novo_patrimonio

@app.put("/patrimonios/{id}", response_model=Patrimonio, status_code=status.HTTP_200_OK)
def atualizar_patrimonio(id: int, patrimonio: PatrimonioBase):
    for i, p in enumerate(patrimonios_db):
        if p.id == id:
            patrimonio_atualizado = Patrimonio(id=id, **patrimonio.model_dump())
            patrimonios_db[i] = patrimonio_atualizado
            return patrimonio_atualizado
    raise HTTPException(status_code=404, detail="Patrimônio não encontrado")

@app.delete("/patrimonios/{id}", status_code=status.HTTP_200_OK)
def excluir_patrimonio(id: int):
    for i, p in enumerate(patrimonios_db):
        if p.id == id:
            del patrimonios_db[i]
            return {"mensagem": "Patrimônio excluído com sucesso"}
    raise HTTPException(status_code=404, detail="Patrimônio não encontrado")