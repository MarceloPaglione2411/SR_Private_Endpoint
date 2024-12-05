# SR_Private_Endpoint

Implementar uma Azure Storage Account com uma estrutura de Private Endpoint envolve criar um ambiente seguro para garantir que o acesso ao armazenamento seja realizado exclusivamente através da rede privada, sem exposição à Internet pública. Abaixo está uma visão geral e um exemplo prático:

Visão Geral da Solução: 
Criado estrutura de rede com 2 VMs e 2 Subnets
Deploy de um Storage Account
Deploy de um Azure Files
Mapear Azure Files em clientes Windows e Linux
Configurar Firewall e Virtual Network para acesso ao Storage Account
Configurar Private Endpoint para acesso ao Storage Account
