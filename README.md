# WilsonWithPDI

Funcionamento do Wilson: https://www.youtube.com/watch?v=UVNc_swBKoU

Conjunto de jobs e transformações criados com o PDI, que possibilita a execução de tarefas via Telegram.

A motivação central desse projeto é automatizar algumas tarefas básicas de Administração do ambiente Pentaho.
Por hora, estou utilizando apenas a API do Telegram para disparar a execução das tarefas, mas pretendo extender para o Slack e outros...
Ainda estou trabalhando para adicionar multiplus servidores, por hora, todo o processo só comporta um servidor.

<br />O processo desenvolvido nesse repositório não serve apenas para execuções no mundo Pentaho, você pode modificar a transformação "executa_comando.ktr", e apontar o comando enviado para o seu processo de execução, seja realizar um dump em alguma base ou interagir com outros processos/programas.

<br />Tentei ser o mais claro possível, nomeando os steps de acordo com a sua função.


### Instalação

Precisamos ter a JDK compativél com a versão do PDI.
Os Jobs e Transformações foram feitas com a versão 6 do Pentaho Data Integrator, porém muitos testes foram executados com a versão 7 e não encontrei falhas na execução.

Link para download do PDI: https://sourceforge.net/projects/pentaho/files/Data%20Integration/
Link para Donwload JDK: preciso colocar?

### Depois de baixar / Configurar...

  A Execução de todo processo pode ser realizada atravéz do "job_principal.kjb"(homenagem/piada interna). 
Esse Job foi desenvolvido utilizando uma abordagem cíclica. Assim sendo, não existe um estado final, ele será executado em loop a cada 10 segundos. Caso queira modificar o intervalo de execução, atualize o Step "Wait for", no "job_principal.kjb".

Na pasta conf, você encontrará três arquivos: biserver.conf, email.conf e mogul_logs.conf.

#### biserver.conf
Temos que informar:<br />
server_ip;<br />
server_port;<br />
server_user;<br />
server_pass.<br />
*Informações do servidor. 

#### email.conf
Temos que informar:<br />
destination_address;<br />
sender_name;<br />
sender_address;<br />
smtp_server;<br />
port;<br />
user_name;<br />
pass.<br />
*Informações de uma conta de email para notificações.

#### mogul_logs.conf
Temos que informar:<br />
type_job;<br />
server_name;<br />
log_patch;<br />
email_notification;<br />
telegram_bot_token;<br />
telegram_bot_id_client.<br />
*Informações do botTelegram para envio de notificações.
<Fazer vídeo explicando como criar e obter tokens> 


Depois de Ajustar os arquivos de configurações, crie um executavel (.sh/.exe) para rodar o "job_principal.kjb" e agende a execução em seu servidor. 
OBS.: O Job é ciclico, não precisa configurar repetições no agendamendo. Uma executado, ele só para matando o processo ou caso ocorra algum erro.

Link: Como executar um .kjb http://wiki.pentaho.com/display/EAI/Kitchen+User+Documentation#KitchenUserDocumentation-Runajobfromfile


### SubETLS / Comandos

Após a captura do comando enviado via telegram, entramos no KTR "executa_comando", aqui temos o coração de todo o processo.
Alguns "comandos/processos" precisão de uma configuração extra. 
Atualmente temos os seguintes comandos implementados:

- stoppentaho - Para o Servidor.<br />
Dependência: Editar o .sh stopPentaho, com o comando de stop do seu servidor.<br />
- startpentaho - Inicia o Servidor<br />
Dependência: Editar o .sh startPentaho, com o comando de start do seu servidor.<br />
- clearcachelvl1 - Limpa os principais caches do pentaho. (Mondrian, CDA e Reporting)<br />
- clearcachelvl2 - Apaga as pastas "tomcat/work" e "tomcat/temp". OBS.: Só utilizar esse comando após parar o serviço do Pentaho.<br />
Dependência: Atualizar o arquivo folder_path.conf, com o caminho para as pastas tomcat/temp e tomcat/work.<br />
- listusers - Lista todos os users cadastrados no pentaho.<br />
- listroles - Lista todas as roles cadastradas no pentaho.<br />

**Importante:**
**Apenas na primeira execução do job_principal.kjb, certifique-se que o last_message_id, contido no arquivo "/commands/ultimocomandotelegram/last_message_id.status" esteja com o valor 0. Esse arquivo é responsável por armazenar o id do último comando enviado do Telegram.**
