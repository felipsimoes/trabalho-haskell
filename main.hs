{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
import Yesod
import Data.Text
import Database.Persist.Postgresql
import Control.Monad.Logger(runStdoutLoggingT)

data Pagina = Pagina{connPool :: ConnectionPool}

instance Yesod Pagina

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|

Usuario json
    email Text
    senha Text
    UniqueUsuario email
    deriving Show

Pessoa json
    nome Text
    cpf Text
    sexo Text
    telefone Text
    dtnascimento Text
    cep Text
    endereco Text
    cidade Text
    nomepai Text
    nomemae Text
    uid UsuarioId
    deriving Show

Ficha json
    alergia Text
    doador Text
    peso Double
    altura Double
    pid PessoaId
    deriving Show
    
Medicamento json
    nome Text
    dosagem Text
    deriving Show

PessoaMedicamentos json
    pid PessoaId
    mid MedicamentoId
    UniquePessoaMedicamentos pid mid

|]


mkYesod "Pagina" [parseRoutes|

/login/usuario/#Text/#Text UsuarioLoginR GET

/cadastro/usuario UsuarioR GET POST
/cadastro/pessoa PessoaR GET POST
/cadastro/ficha FichaR GET POST
/cadastro/medicamento MedicamentoR GET POST
/cadastro/pessoamedicamento PessoaMedicamentoR POST

/consulta/usuario/#UsuarioId UsuarioChecaR GET PUT DELETE
/consulta/pessoa/#PessoaId PessoaChecaR GET PUT DELETE
/consulta/ficha/#FichaId FichaChecaR GET PUT DELETE
/consulta/medicamento/#MedicamentoId MedicamentoChecaR GET PUT DELETE
/consulta/pessoamedicamento/#PessoaId PessoaMedicamentoChecaR GET

/pessoa/usuario/#UsuarioId PessoaUsuarioR GET
/ficha/pessoa/#PessoaId FichaPessoaR GET
|]

instance YesodPersist Pagina where
    type YesodPersistBackend Pagina = SqlBackend
    runDB f = do 
        master <- getYesod
        let pool = connPool master
        runSqlPool f pool

getUsuarioLoginR :: Text -> Text -> Handler Html
getUsuarioLoginR em se = do
    addHeader "Access-Control-Allow-Origin" "*"
    res <- runDB $ getBy404 (UniqueUsuario em)
    sendResponse (object [  pack "senha" .= usuarioSenha (entityVal res),
                            pack "uid" .= fromSqlKey ((entityKey res)) ])
        
getUsuarioR :: Handler ()
getUsuarioR = do
    addHeader "Access-Control-Allow-Origin" "*"
    allUsuario <- runDB $ selectList [] [Asc UsuarioId ]
    sendResponse (object [pack "data" .= fmap toJSON allUsuario])

postUsuarioR :: Handler ()
postUsuarioR = do
    addHeader "Access-Control-Allow-Origin" "*"
    usuario <- requireJsonBody :: Handler Usuario
    idUsuario <- runDB $ insert usuario
    sendResponse (object [  pack "resp" .= pack "Criado",
                            pack "idUsuario" .= show (fromSqlKey idUsuario)])

getUsuarioChecaR :: UsuarioId -> Handler Html
getUsuarioChecaR pid = do
    addHeader "Access-Control-Allow-Origin" "*"
    usuario <- runDB $ get404 pid
    sendResponse (object [  pack "email" .= usuarioEmail usuario,
                            pack "senha" .= usuarioSenha usuario])


putUsuarioChecaR :: UsuarioId -> Handler ()
putUsuarioChecaR uid = do
    addHeader "Access-Control-Allow-Origin" "*"
    usuario <- requireJsonBody :: Handler Usuario 
    runDB $ update uid [UsuarioSenha =. usuarioSenha usuario]
    sendResponse (object [pack "resp" .= pack "Alterado"])

deleteUsuarioChecaR :: UsuarioId -> Handler ()
deleteUsuarioChecaR uid = do
    addHeader "Access-Control-Allow-Origin" "*"
    runDB $ delete uid
    sendResponse (object [pack "resp" .= pack "Excluido"])


getPessoaR :: Handler ()
getPessoaR = do
    addHeader "Access-Control-Allow-Origin" "*"
    allPessoa <- runDB $ selectList [] [Asc PessoaNome ]
    sendResponse (object [pack "data" .= fmap toJSON allPessoa])

postPessoaR :: Handler ()
postPessoaR = do
    addHeader "Access-Control-Allow-Origin" "*"
    pessoa <- requireJsonBody :: Handler Pessoa
    idPessoa <- runDB $ insert pessoa
    sendResponse (object [  pack "resp" .= pack "Criado",
                            pack "idPessoa" .= show (fromSqlKey idPessoa)])

getPessoaChecaR :: PessoaId -> Handler Html
getPessoaChecaR pid = do
    addHeader "Access-Control-Allow-Origin" "*"
    pessoa <- runDB $ get404 pid
    sendResponse (object [  pack "nome" .= pessoaNome pessoa, 
                            pack "cpf" .= pessoaCpf pessoa,
                            pack "sexo" .=  pessoaSexo pessoa ,
                            pack "telefone" .=  pessoaTelefone pessoa ,
                            pack "dtnascimento" .=  pessoaDtnascimento pessoa ,
                            pack "cep" .= pessoaCep pessoa ,
                            pack "endereco" .= pessoaEndereco pessoa ,
                            pack "cidade" .= pessoaCidade pessoa ,
                            pack "nomepai" .= pessoaNomepai pessoa ,
                            pack "nomemae" .= pessoaNomemae pessoa ])
    

deletePessoaChecaR :: PessoaId -> Handler ()
deletePessoaChecaR pid = do
    addHeader "Access-Control-Allow-Origin" "*"
    runDB $ delete pid
    sendResponse (object [pack "resp" .= pack "Excluido"])
    
putPessoaChecaR :: PessoaId -> Handler ()
putPessoaChecaR pid = do
    addHeader "Access-Control-Allow-Origin" "*"
    pessoa <- requireJsonBody :: Handler Pessoa
    runDB $ update pid [PessoaNome =. pessoaNome pessoa,
                        PessoaCpf =. pessoaCpf pessoa,
                        PessoaSexo =. pessoaSexo pessoa,
                        PessoaTelefone =. pessoaTelefone pessoa,
                        PessoaDtnascimento =. pessoaDtnascimento pessoa,
                        PessoaCep =. pessoaCep pessoa,
                        PessoaEndereco =. pessoaEndereco pessoa,
                        PessoaCidade =. pessoaCidade pessoa,
                        PessoaNomepai =. pessoaNomepai pessoa,
                        PessoaNomemae =. pessoaNomemae pessoa]
    sendResponse (object [pack "resp" .= pack "Alterado"])
    
getFichaR :: Handler ()
getFichaR = do
    addHeader "Access-Control-Allow-Origin" "*"
    allFicha <- runDB $ selectList [] [Asc FichaAlergia ]
    sendResponse (object [pack "data" .= fmap toJSON allFicha])

postFichaR :: Handler ()
postFichaR = do
    addHeader "Access-Control-Allow-Origin" "*"
    ficha <- requireJsonBody :: Handler Ficha
    runDB $ insert ficha
    sendResponse (object [pack "resp" .= pack "Criado"])

getFichaChecaR :: FichaId -> Handler Html
getFichaChecaR pid = do
    addHeader "Access-Control-Allow-Origin" "*"
    ficha <- runDB $ get404 pid
    sendResponse (object [  pack "alergia" .= fichaAlergia ficha,
                            pack "doador" .= fichaDoador ficha,
                            pack "peso" .= fichaPeso ficha,
                            pack "altura" .= fichaAltura ficha ])

deleteFichaChecaR :: FichaId -> Handler ()
deleteFichaChecaR fid = do
    addHeader "Access-Control-Allow-Origin" "*"
    runDB $ delete fid
    sendResponse (object [pack "resp" .= pack "Excluido"])
    
putFichaChecaR :: FichaId -> Handler ()
putFichaChecaR fid = do
    addHeader "Access-Control-Allow-Origin" "*"
    ficha <- requireJsonBody :: Handler Ficha
    runDB $ update fid [FichaAlergia =. fichaAlergia ficha,
                        FichaDoador =. fichaDoador ficha,
                        FichaPeso =. fichaPeso ficha,
                        FichaAltura =. fichaAltura ficha]
    sendResponse (object [pack "resp" .= pack "Alterado"])


getMedicamentoR :: Handler ()
getMedicamentoR = do
    addHeader "Access-Control-Allow-Origin" "*"
    allMedicamento <- runDB $ selectList [] [Asc MedicamentoNome ]
    sendResponse (object [pack "data" .= fmap toJSON allMedicamento])

postMedicamentoR :: Handler ()
postMedicamentoR = do
    addHeader "Access-Control-Allow-Origin" "*"
    medicamento <- requireJsonBody :: Handler Medicamento
    idMedicamento <- runDB $ insert medicamento
    sendResponse (object [  pack "resp" .= pack "Criado",
                            pack "idMedicamento" .= show (fromSqlKey idMedicamento)])

getMedicamentoChecaR :: MedicamentoId -> Handler Html
getMedicamentoChecaR pid = do
    addHeader "Access-Control-Allow-Origin" "*"
    medicamento <- runDB $ get404 pid
    sendResponse (object [  pack "nome" .= medicamentoNome medicamento,
                            pack "dosagem" .= medicamentoDosagem medicamento ])
    
deleteMedicamentoChecaR :: MedicamentoId -> Handler ()
deleteMedicamentoChecaR mid = do
    addHeader "Access-Control-Allow-Origin" "*"
    runDB $ delete mid
    sendResponse (object [pack "resp" .= pack "Excluido"])
    
putMedicamentoChecaR :: MedicamentoId -> Handler ()
putMedicamentoChecaR mid = do
    addHeader "Access-Control-Allow-Origin" "*"
    medicamento <- requireJsonBody :: Handler Medicamento
    runDB $ update mid [MedicamentoNome =. medicamentoNome medicamento,
                        MedicamentoDosagem =. medicamentoDosagem medicamento]
    sendResponse (object [pack "resp" .= pack "Alterado"])

postPessoaMedicamentoR :: Handler ()
postPessoaMedicamentoR = do
    addHeader "Access-Control-Allow-Origin" "*"
    relacao <- requireJsonBody :: Handler PessoaMedicamentos
    runDB $ insert relacao
    sendResponse (object [pack "resp" .= pack "Criado"])

getPessoaMedicamentoChecaR :: PessoaId -> Handler ()
getPessoaMedicamentoChecaR pid = do
    addHeader "Access-Control-Allow-Origin" "*"
    allMedicamento <- runDB $ (rawSql (pack $ "SELECT ?? FROM medicamento \ 
     INNER JOIN pessoa_medicamentos \
     ON medicamento.id=pessoa_medicamentos.mid \
     WHERE pessoa_medicamentos.pid = " ++ (show $ fromSqlKey pid)) [])::Handler [(Entity Medicamento)]
    sendResponse (object [pack "data" .= fmap toJSON allMedicamento]) 

getPessoaUsuarioR :: UsuarioId -> Handler ()
getPessoaUsuarioR uid = do
    addHeader "Access-Control-Allow-Origin" "*"
    res <- runDB $ selectFirst [PessoaUid ==. uid] []
    sendResponse (object [  pack "data" .= res ])

getFichaPessoaR :: PessoaId -> Handler ()
getFichaPessoaR pid = do
    addHeader "Access-Control-Allow-Origin" "*"
    res <- runDB $ selectFirst [FichaPid ==. pid] []
    sendResponse (object [  pack "data" .= res ])
   
connStr = "dbname=d4htbg71jrvj1f host=ec2-107-20-174-127.compute-1.amazonaws.com user=kcepfkqlcfbgpx password=ypVq9Yx6t4Q1InDMvoT-yR7Idk port=5432"

main :: IO ()
main = runStdoutLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do
runSqlPersistMPool (runMigration migrateAll) pool
warp 8080 (Pagina pool)







