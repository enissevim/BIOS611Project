docker build . -t BIOS611Project

docker run -e USERID=$(id -u) -e GROUPID(id -g)\
  -v $(pwd):/home/rstudio/work\
  -v $HOME/.ssh:/home/rstudio/.ssh\
  -v HOME/.gitconfig:/home/rstudio/.gitconfig\
  -p 8787:8787 -it BIOS611Project