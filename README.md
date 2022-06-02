# rocket-web-app-beta

my try in creating a rust web app...

## environmental requirements

install dependencies:

```bash:
sudo apt install build-essential
```

install docker:

```bash:
sudo apt-get install ca-certificates curl gnupg lsb-release
```

```bash:
sudo mkdir -p /etc/apt/keyrings
```

```bash:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

```bash:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

```bash:
sudo apt-get update
```

```bash:
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

```bash:
curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
```

```bash:
sudo chmod +x /usr/local/bin/docker-compose
```

```bash:
sudo docker run hello-world
```

install rust:

```bash:
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

clone repo:

```bash:
git clone https://github.com/jbadenho/rocket-web-app-beta.git
```

init project:

```bash:
cargo init rocket-web-app-beta/ --bin
```

```bash:
cd rocket-web-app-beta
```

ready for rocket

```bash:
rustup default nightly
```

```bash:
rustup override set nightly
```

```bash:
rustup update && cargo update
```

run project

```bash:
cargo run
```
