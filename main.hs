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
/cadastro/usuario UsuarioR GET POST
/cadastro/pessoa PessoaR GET POST
/cadastro/ficha FichaR GET POST
/cadastro/medicamento MedicamentoR GET POST
/consulta/usuario/#UsuarioId UsuarioChecaR GET PUT DELETE
/consulta/pessoa/#PessoaId PessoaChecaR GET PUT DELETE
/consulta/ficha/#FichaId FichaChecaR GET
/consulta/medicamento/#MedicamentoId MedicamentoChecaR GET
|]

instance YesodPersist Pagina where
    type YesodPersistBackend Pagina = SqlBackend
    runDB f = do 
        master <- getYesod
        let pool = connPool master
        runSqlPool f pool
        

getUsuarioR :: Handler ()
getUsuarioR = do
    addHeader "Access-Control-Allow-Origin" "*"
    allUsuario <- runDB $ selectList [] [Asc UsuarioId ]
    sendResponse (object [pack "data" .= fmap toJSON allUsuario])

postUsuarioR :: Handler ()
postUsuarioR = do
    addHeader "Access-Control-Allow-Origin" "*"
    usuario <- requireJsonBody :: Handler Usuario
    runDB $ insert usuario
    sendResponse (object [pack "resp" .= pack "Criado"])

getUsuarioChecaR :: UsuarioId -> Handler Html
getUsuarioChecaR pid = do
    usuario <- runDB $ get404 pid
    defaultLayout [whamlet|
        <p><b> #{usuarioEmail usuario}  
        <p><b> #{usuarioSenha usuario}
    |]


putUsuarioChecaR :: UsuarioId -> Handler ()
putUsuarioChecaR uid = do
    usuario <- requireJsonBody :: Handler Usuario 
    runDB $ update uid [UsuarioSenha =. usuarioSenha usuario]
    sendResponse (object [pack "resp" .= pack "Alterado"])

deleteUsuarioChecaR :: UsuarioId -> Handler ()
deleteUsuarioChecaR uid = do
    runDB $ delete uid
    sendResponse (object [pack "resp" .= pack "Excluido"])


getPessoaR :: Handler ()
getPessoaR = do
    addHeader "Access-Control-Allow-Origin" "*"
    allPessoa <- runDB $ selectList [] [Asc PessoaNome ]
    sendResponse (object [pack "data" .= fmap toJSON allPessoa])

postPessoaR :: Handler ()
postPessoaR = do
    pessoa <- requireJsonBody :: Handler Pessoa
    runDB $ insert pessoa
    sendResponse (object [pack "resp" .= pack "Criado"])

getPessoaChecaR :: PessoaId -> Handler Html
getPessoaChecaR pid = do
    pessoa <- runDB $ get404 pid
    defaultLayout [whamlet|
        <p><b> #{pessoaNome pessoa}  
        <p><b> #{pessoaCpf pessoa}
        <p><b> #{pessoaSexo pessoa}
        <p><b> #{pessoaTelefone pessoa}
        <p><b> #{pessoaDtnascimento pessoa}
        <p><b> #{pessoaCep pessoa}
        <p><b> #{pessoaEndereco pessoa}
        <p><b> #{pessoaCidade pessoa}
        <p><b> #{pessoaNomepai pessoa}
        <p><b> #{pessoaNomemae pessoa}
    |]

deletePessoaChecaR :: PessoaId -> Handler ()
deletePessoaChecaR pid = do
    runDB $ delete pid
    sendResponse (object [pack "resp" .= pack "Excluido"])
    
putPessoaChecaR :: PessoaId -> Handler ()
putPessoaChecaR pid = do
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
    ficha <- requireJsonBody :: Handler Ficha
    runDB $ insert ficha
    sendResponse (object [pack "resp" .= pack "Criado"])

getFichaChecaR :: FichaId -> Handler Html
getFichaChecaR pid = do
    ficha <- runDB $ get404 pid
    defaultLayout [whamlet|
        <p><b> #{fichaAlergia ficha}
        <p><b> #{fichaDoador ficha}
        <p><b> #{fichaPeso ficha}
        <p><b> #{fichaAltura ficha}
    |]

deleteFichaChecaR :: FichaId -> Handler ()
deleteFichaChecaR pid = do
    runDB $ delete pid
    sendResponse (object [pack "resp" .= pack "Excluido"])
    
putFichaChecaR :: PessoaId -> Handler ()
putFichaChecaR pid = do
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



getMedicamentoR :: Handler ()
getMedicamentoR = do
    addHeader "Access-Control-Allow-Origin" "*"
    allMedicamento <- runDB $ selectList [] [Asc MedicamentoNome ]
    sendResponse (object [pack "data" .= fmap toJSON allMedicamento])

postMedicamentoR :: Handler ()
postMedicamentoR = do
    medicamento <- requireJsonBody :: Handler Medicamento
    runDB $ insert medicamento
    sendResponse (object [pack "resp" .= pack "Criado"])

getMedicamentoChecaR :: MedicamentoId -> Handler Html
getMedicamentoChecaR pid = do
    medicamento <- runDB $ get404 pid
    defaultLayout [whamlet|
        <p><b> #{medicamentoNome medicamento}
        <p><b> #{medicamentoDosagem medicamento}    
        
    |]



connStr = "dbname=d4htbg71jrvj1f host=ec2-107-20-174-127.compute-1.amazonaws.com user=kcepfkqlcfbgpx password=ypVq9Yx6t4Q1InDMvoT-yR7Idk port=5432"

main :: IO ()
main = runStdoutLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do
runSqlPersistMPool (runMigration migrateAll) pool
warp 8080 (Pagina pool)





