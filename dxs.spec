%define git_version %(git describe --tags 2> /dev/null || echo 0.0-`git log --oneline | wc -l`-g`git describe --always`)

%define git_get_ver %(echo %{git_version} | sed 's/^v\\?\\(.*\\)-\\([0-9]\\+\\)-g.*$/\\1/;s/-//')
%define git_get_rel %(echo %{git_version} | sed 's/^v\\?\\(.*\\)-\\([0-9]\\+-g.*\\)$/\\2/;s/-/_/')

Name:      dextrose-server
Summary:   Dextrose server deployment scripts
Version:   %git_get_ver
Release:   %git_get_rel
License:   GPLv3
Group:     Applications/System
Source:    %{expand:%%(pwd)}
BuildArch: noarch
Requires: bash, python >= 2.7, ansible >= 1.3
URL:       http://github.com/activitycentral/dxs.git
Provides:  dextrose-server

BuildRoot: %{_topdir}/BUILD/%{name}-%{version}-%{release}

%description
Ansible playbook collection for dextrose server project, implementing Activity Central's vision of a School Server appliance with enterprise support. DXS closely tracks the XSCE (School Server Community Edition), both in vision and software development.


%prep
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/bin
mkdir -p $RPM_BUILD_ROOT/var/local/dxs
mkdir -p $RPM_BUILD_ROOT/usr/local/share/doc/dxs/

cd $RPM_BUILD_ROOT

cp -rf %{SOURCEURL0}/roles ./var/local/dxs/
cp -rf %{SOURCEURL0}/vars ./var/local/dxs/
cp -rf %{SOURCEURL0}/dxs*.yml ./var/local/dxs
cp -rf %{SOURCEURL0}/ansible_hosts ./var/local/dxs
cp -rf %{SOURCEURL0}/docs/* ./usr/local/share/doc/dxs/
cp %{SOURCEURL0}/runansible ./usr/bin/

%clean
rm -r -f "$RPM_BUILD_ROOT"

%files
/usr/bin/runansible
/var/local/dxs
%doc /usr/local/share/doc/dxs
