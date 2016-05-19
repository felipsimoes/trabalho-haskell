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
    
|]

mkYesod "Pagina" [parseRoutes|
/cadastro/usuario UsuarioR GET POST
/consulta/usuario/#UsuarioId UsuarioChecaR GET
--/cadastro/pessoa GET POST
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

connStr = "dbname=d4htbg71jrvj1f host=ec2-107-20-174-127.compute-1.amazonaws.com user=kcepfkqlcfbgpx password=ypVq9Yx6t4Q1InDMvoT-yR7Idk port=5432"

main :: IO ()
main = runStdoutLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do
runSqlPersistMPool (runMigration migrateAll) pool
warp 8080 (Pagina pool)





