FROM debian:jessie

#Pre-Installation
RUN apt-get -y update && \
    apt-get -y --force-yes install wget tomcat7

RUN apt-get -y --force-yes install unzip && \
    cd /tmp && \
    wget "http://www.eclipse.org/downloads/download.php?file=/birt/downloads/drops/M-R1-4_5_0RC4-201506092134/birt-runtime-4.5.0-20150609.zip" -O birt-runtime.zip && \
    unzip birt-runtime.zip && \
    mv birt-runtime-*/WebViewerExample /var/lib/tomcat7/webapps/birt && \
    rm birt-runtime.zip && \
    rm -rf birt-runtime-* && \
    apt-get remove -y unzip

RUN ln -s /etc/tomcat7 /usr/share/tomcat7/conf
RUN ln -s /var/lib/tomcat7/webapps/ /usr/share/tomcat7/webapps

#Add JDBC

RUN cd /tmp && \
    wget "http://download.microsoft.com/download/0/2/A/02AAE597-3865-456C-AE7F-613F99F850A8/sqljdbc_4.1.5605.100_enu.tar.gz" && \
    tar xzf sqljdbc_*.tar.gz -C /var/lib/tomcat7/webapps/birt/WEB-INF/lib/ --strip-components=2 sqljdbc_4.1/enu/sqljdbc41.jar && \
    rm sqljdbc*.tar.gz

RUN wget "https://jdbc.postgresql.org/download/postgresql-9.4-1201.jdbc41.jar" -P "/var/lib/tomcat7/webapps/birt/WEB-INF/lib"

RUN cd /tmp && \
    wget "http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.0.8.tar.gz" && \
    tar xzf mysql-connector-java-*.tar.gz -C /var/lib/tomcat7/webapps/birt/WEB-INF/lib/ --strip-components=1 mysql-connector-java-5.0.8/mysql-connector-java-5.0.8-bin.jar && \
    rm /tmp/mysql-connector-java-*

# Map Reports folder
VOLUME /var/lib/tomcat7/webapps/birt/reports
VOLUME /var/lib/tomcat7/webapps/birt/logs

# Modify birt viewer setting for reports path issue
RUN perl -i -p0e "s/BIRT_VIEWER_WORKING_FOLDER<\/param-name>\n\t\t<param-value>/BIRT_VIEWER_WORKING_FOLDER<\/param-name>\n\t\t<param-value>\/var\/lib\/tomcat7\/webapps\/birt\//smg" /var/lib/tomcat7/webapps/birt/WEB-INF/web.xml

#Start
CMD /usr/share/tomcat7/bin/catalina.sh run

#Port
EXPOSE 8080
