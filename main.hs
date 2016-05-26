{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
import Yesod
import Database.Persist.Postgresql
import Data.Text
import Control.Monad.Logger(runStdoutLoggingT)

data Pagina = Pagina{connPool :: ConnectionPool}

instance Yesod Pagina

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|

Usuario json
    nome Text
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
    deriving Show
    
|]


mkYesod "Pagina" [parseRoutes|
/cadastro/usuario UsuarioR GET POST
/cadastro/pessoa PessoaR GET POST
/consulta/usuario/#UsuarioId UsuarioChecaR GET
/consulta/pessoa/#PessoaId PessoaChecaR GET
|]

instance YesodPersist Pagina where
    type YesodPersistBackend Pagina = SqlBackend
    runDB f = do 
        master <- getYesod
        let pool = connPool master
        runSqlPool f pool
        
--FUNÇOES

getUsuarioR :: Handler ()
getUsuarioR = do
    addHeader "Access-Control-Allow-Origin" "*"
    allUsuario <- runDB $ selectList [] [Asc UsuarioNome ]
    sendResponse (object [pack "data" .= fmap toJSON allUsuario])

postUsuarioR :: Handler ()
postUsuarioR = do
    usuario <- requireJsonBody :: Handler Usuario
    runDB $ insert usuario
    sendResponse (object [pack "resp" .= pack "Criado"])

getUsuarioChecaR :: UsuarioId -> Handler Html
getUsuarioChecaR pid = do
    usuario <- runDB $ get404 pid
    defaultLayout [whamlet|
        <p><b> #{usuarioNome usuario}  
        <p><b> #{usuarioSenha usuario}
    |]

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


connStr = "dbname=d4htbg71jrvj1f host=ec2-107-20-174-127.compute-1.amazonaws.com user=kcepfkqlcfbgpx password=ypVq9Yx6t4Q1InDMvoT-yR7Idk port=5432"

main :: IO ()
main = runStdoutLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do
runSqlPersistMPool (runMigration migrateAll) pool
warp 8080 (Pagina pool)





