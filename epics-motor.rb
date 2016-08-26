# vim: ts=2 sw=2 sts=2

require './epics-base'

class EpicsMotor < Formula
  desc "APS BCDA synApps module: motor"
  homepage "http://www.aps.anl.gov/bcda/synApps/motor/index.html"
  url "https://github.com/epics-modules/motor/archive/R6-9.tar.gz"
  version "6-9"
  sha256 "3b33ccd72c41afffb8613867907760da18a0a0cf6ee0e486b6e738bb00c0997b"

  depends_on "epics-base"
  depends_on "epics-asyn"
  depends_on "epics-seq"

  def install
    asyn_path = get_package_prefix('epics-asyn')
    sncseq_path = get_package_prefix('epics-seq')
  
    # Sorry, no IPAC support
    inreplace "configure/RELEASE", /^IPAC=.*$/, "#IPAC="
    inreplace "motorApp/Makefile", /^DIRS \+= HytecSrc/, "# hytec requires ipac"

    system("make", "SNCSEQ=#{sncseq_path}", "ASYN=#{asyn_path}",
           "INSTALL_LOCATION=#{prefix}", 
           *get_epics_make_variables())

    # host_arch = get_epics_host_arch()
    # File.unlink bin/"#{host_arch}/test"
    wrap_epics_binaries() # , :skip_names=['test'])
  end

  test do
    system "echo exit | motorSim"
  end
end