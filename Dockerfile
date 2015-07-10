FROM tomcat:8

ENV BIRT_URL http://www.eclipse.org/downloads/download.php?file=/birt/downloads/drops/M-R1-4_5_0RC4-201506092134/birt-runtime-4.5.0-20150609.zip
ENV BIRT_HOME $CATALINA_HOME/webapps/birt

RUN curl -fSL "$BIRT_URL" -o birt-runtime.zip && \
    unzip birt-runtime.zip && \
    mv birt-runtime-*/WebViewerExample $BIRT_HOME && \
    rm birt-runtime.zip && \
    rm -rf birt-runtime-*

##
## JDBC
##

RUN cd /tmp && \
    curl -fSL "http://download.microsoft.com/download/0/2/A/02AAE597-3865-456C-AE7F-613F99F850A8/sqljdbc_4.1.5605.100_enu.tar.gz" -o sqljdbc.tar.gz && \
    tar xzf sqljdbc.tar.gz -C $BIRT_HOME/WEB-INF/lib/ --strip-components=2 sqljdbc_4.1/enu/sqljdbc41.jar && \
    rm sqljdbc.tar.gz

RUN curl -fSL "https://jdbc.postgresql.org/download/postgresql-9.4-1201.jdbc41.jar" -o $BIRT_HOME/WEB-INF/lib/postgresql-9.4-1201.jdbc41.jar

RUN curl -fSL "http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.0.8.tar.gz" -o mysql-connector-java.tar.gz && \
    tar xzf mysql-connector-java.tar.gz -C $BIRT_HOME/WEB-INF/lib/ --strip-components=1 mysql-connector-java-5.0.8/mysql-connector-java-5.0.8-bin.jar && \
    rm mysql-connector-java.tar.gz

VOLUME $BIRT_HOME/reports
VOLUME $BIRT_HOME/logs
