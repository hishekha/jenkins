# Introduction
This is a sample docker image projects that builds jenkin imag on ubuntu with oracle jdk8 and maven 3.3.9


#Build
```bash
docker build -t hshekhar/jenkins:latest .
```

#Run 
```bash
docker run --name hshekharCI \
    -p 8080:8080
    -p 5000:5000
    hshekhar/jenkins:latest
```