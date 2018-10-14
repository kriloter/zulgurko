let
  lvirt = {
    deployment.targetEnv = "libvirtd";
    deployment.libvirtd.headless = true;
    deployment.libvirtd.memorySize = 1024;
    deployment.libvirtd.vcpu = 2;
    # deployment image size in GB, default is 10GB
#    deployment.libvirtd.baseImageSize = 20;
    deployment.libvirtd.networks = [ { type="bridge"; source="br0"; } ];
    deployment.libvirtd.extraDevicesXML = ''
      <serial type='pty'>
        <target port='0'/>
      </serial>
      <console type='pty'>
        <target type='serial' port='0'/>
      </console>
    '';
  };
in
{
  network.description = "netX";

  postgres1     = lvirt;
  web1     = lvirt;
}
