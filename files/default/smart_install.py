# Patch RequirementSet.install to collect to our array
to_install=[]
from pip.req import RequirementSet
def my_install(self, install_options, global_options=(), *args, **kwargs):
    global to_install
    to_install.extend([r for r in self.requirements.values() if not r.satisfied_by])
RequirementSet.install = my_install

# Patch WheelBuilder.build to do nothing
from pip.wheel import  WheelBuilder
def my_build(self, autobuilding):
    pass
WheelBuilder.build = my_build

# Emulate `pip install`
import pip
import sys
args = sys.argv[1:]
if '-q' not in args: args.append('-q') # keep it quiet
pip.main(args)

#print 'to_install is',[r.name for r in to_install]
print any(to_install)
