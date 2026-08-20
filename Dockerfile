FROM tomcat:9.0-jdk17

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy web resources
COPY web/ /usr/local/tomcat/webapps/ROOT/

# Copy Java source and compile
COPY src/ /tmp/src/
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/classes && \
    find /tmp/src -name "*.java" > /tmp/sources.txt && \
    javac -cp /usr/local/tomcat/lib/servlet-api.jar \
          -d /usr/local/tomcat/webapps/ROOT/WEB-INF/classes \
          @/tmp/sources.txt && \
    rm -rf /tmp/src /tmp/sources.txt

# Configure Tomcat to use PORT env variable (required by Render)
RUN sed -i 's/port="8080"/port="${PORT:-8080}"/' /usr/local/tomcat/conf/server.xml

EXPOSE 8080

CMD ["catalina.sh", "run"]
