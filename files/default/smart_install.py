from pip.req import RequirementSet

to_install=[]

def my_install(self, install_options, global_options=(), *args, **kwargs):
    global to_install
    to_install.extend([r for r in self.requirements.values() if not r.satisfied_by])

RequirementSet.install = my_install

import pip
import sys
args = sys.argv[1:]
if '-q' not in args: args.append('-q') # keep it quiet
pip.main(args)

#print 'to_install is',[r.name for r in to_install]
print any(to_install)
