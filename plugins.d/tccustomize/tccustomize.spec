Name:           tccustomize
Version:        0
Release:        1

Summary:        Tiny Core Linux modified to run on all OLPC XO laptops

Group:          System Environment/Base
License:        GPLv2

URL:            http://wiki.laptop.org/go/Tiny_Core_Linux
%global         path1		http://dev.laptop.org/~quozl/mktinycorexo/mktinycorexo                      


BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildArch:     noarch
BuildRequires: git
BuildRequires: wget


%description
This package contains a commplete Tiny Core OS for the XO Laptops v1,1.5.1.75,4

%prep
%setup -q  -c -T


%build


%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/share/xs-config/tccustomize/
rsync -rp /root/tccustomize/mktinycorexo/output/boot $RPM_BUILD_ROOT/usr/share/xs-config/tccustomize
rsync /root/tccustomize/mktinycorexo/HOWTO* $RPM_BUILD_ROOT/usr/share/xs-config/tccustomize
rsync /root/tccustomize/mktinycorexo/ANNOUNCE $RPM_BUILD_ROOT/usr/share/xs-config/tccustomize

%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
/usr/share/xs-config/tccustomize/*


%changelog
