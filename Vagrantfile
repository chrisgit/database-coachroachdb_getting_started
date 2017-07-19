VAGRANTFILE_API_VERSION = '2'

# Three cockroach instances running in containers
$create_cluster =<<EOF
chmod +x /opt/cockroach/scripts/create_cluster.sh
/opt/cockroach/scripts/create_cluster.sh
EOF

# Create a basic database
$create_bank_database =<<EOF
docker exec -it roach1 /bin/bash -c "./cockroach sql --insecure < /scripts/create_bank_database.sql"
EOF

$post_boot_message =<<EOF
Underground will live forever baby. We're just like roaches, never dying, always living, and on that note, lets get back to the program ...

################
Congratulations!
################

You now have a cockroachdb cluster running in Docker containers.
See https://www.cockroachlabs.com/docs/stable/start-a-local-cluster-in-docker.html#os-linux
If you want to create the bank database then login to the VM with vagrant ssh and run the following command

docker exec -it roach1 /bin/bash -c "./cockroach sql --insecure < /scripts/create_bank_database.sql"

EOF

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu/trusty64'
  
  config.vm.define 'cockroachdb' do |v|
    v.vm.provider 'virtualbox' do |vb|
      vb.customize ['setextradata', 'global', 'GUI/SuppressMessages', 'all' ]
      vb.customize ['modifyvm', :id, '--ioapic', 'on']
      vb.cpus = 1
      vb.memory = 1024
      vb.linked_clone = true
    end
    v.vm.hostname = 'cockroachdb'
    v.vm.network 'private_network', ip: '172.20.20.10'
    v.vm.network :forwarded_port, host: 8080, guest: 8080
    v.vm.provision 'docker' do |docker|
      docker.pull_images 'cockroachdb/cockroach:v1.0.3'
    end
    v.vm.synced_folder './cockroach', '/opt/cockroach', create: true    
    
    v.vm.provision 'shell', inline: $create_cluster
    v.vm.post_up_message = $post_boot_message
  end
end
