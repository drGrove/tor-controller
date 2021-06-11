local Pipeline(
  name,
  steps,
      ) = {
  kind: 'pipeline',
  type: 'docker',
  name: name,
  steps: steps,
};

local install_kubebuilder(golang_version) = {
  name: 'Install Kubebulider',
  image: 'golang:' + golang_version,
  commands: [
    'curl -L -O https://github.com/kubernetes-sigs/kubebuilder/releases/download/v0.1.10/kubebuilder_0.1.10_linux_amd64.tar.gz',
    'tar -zxvf kubebuilder_0.1.10_linux_amd64.tar.gz',
    'mv kubebuilder_0.1.10_linux_amd64 ~/kubebuilder',
    'export PATH=$PATH:~/kubebuilder',
    'export TEST_ASSET_ETCD=~/kubebuilder/bin/etcd',
    'export TEST_ASSET_KUBE_APISERVER=~/kubebuilder/bin/kube-apiserver',
  ],
};

local run_test(golang_version) = {
  name: 'Go Test',
  image: 'golang:' + golang_version,
  commands: [
    'go test ./pkg/...',
  ],
};

[
  Pipeline(
    name='golang-1.16.5',
    steps=[
      install_kubebuilder('1.16.5-stretch'),
      run_test('1.16.5-stretch'),
    ],
  ),
]
