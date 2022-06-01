# rocket-web-app-beta
my try in creating a rust web app...

## environmental requirements:

install dependencies
sudo apt install build-essential

install docker
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo docker run hello-world

install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

clone repo
git clone https://github.com/jbadenho/rocket-web-app-beta.git

init project
cargo init rocket-web-app-beta/ --bin
cd rocket-web-app-beta

ready for rocket
rustup default nightly
rustup override set nightly
rustup update && cargo update

run project
cargo run
