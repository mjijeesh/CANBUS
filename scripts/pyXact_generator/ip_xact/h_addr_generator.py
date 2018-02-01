################################################################################                                                     
## 
##   CAN with Flexible Data-Rate IP Core 
##   
##   Copyright (C) 2018 Ondrej Ille <ondrej.ille@gmail.com>
##
##   Address map generator to C header file.  
## 
##	Revision history:
##		25.01.2018	First implementation
##
################################################################################

from abc import ABCMeta, abstractmethod
from pyXact_generator.ip_xact.addr_generator import IpXactAddrGenerator

from pyXact_generator.languages.gen_h import HeaderGenerator
from pyXact_generator.languages.declaration import LanDeclaration

class HeaderAddrGenerator(IpXactAddrGenerator):

	headerGen = None

	def __init__(self, pyXactComp, addrMap, fieldMap, busWidth):
		super().__init__(pyXactComp, addrMap, fieldMap, busWidth)
		self.headerGen = HeaderGenerator()
	
	
	def commit_to_file(self):
		for line in self.headerGen.out :
			self.of.write(line)
	
	

	def write_reg_group(self, regGroup, addrReg):
		decls = []
		enumDecl = []
		for reg in regGroup:
			for (i,field) in enumerate(sorted(reg.field, key=lambda a: a.bitOffset)):
				
				if (i == 0):
					comment = reg.name.upper()
				else:
					comment = None
				
				decls.append(LanDeclaration(field.name.lower(), value=0, 
							type="uint{}_t".format(self.busWidth),
							bitWidth=field.bitWidth,
							gap=2, alignLen=40, comment=comment,
							bitIndex=field.bitOffset + 
									((int(reg.addressOffset)*8) % self.busWidth), 
							intType="bitfield"))
			
		enumDecl = []
		enumDecl.append(LanDeclaration("u{}".format(self.busWidth),
							value=0, type="uint{}_t".format(self.busWidth),
							gap=1))
		enumDecl.append(decls)
		
		self.headerGen.create_union(addrReg.name.lower(), enumDecl)
		self.headerGen.wr_nl()
	
	def addr_reg_lookup(self, fieldReg):
		for block in self.addrMap.addressBlock:
			for reg in block.register:
				if (reg.addressOffset * 4 == fieldReg.addressOffset):
					return reg
		return None
	
	
	def write_regs(self, regs):
		regGroups = [[]]
		lowInd = 0
		
		# Sort the registers from field map into sub-lists	
		for reg in sorted(regs, key=lambda a: a.addressOffset):
			
			# We hit the register aligned create new group
			if (reg.addressOffset >= lowInd + self.busWidth / 8):
				lowInd = reg.addressOffset - reg.addressOffset % 4
				regGroups.append([])
	
			regGroups[-1].append(reg)
			
		for regGroup in regGroups:
			self.write_reg_group(regGroup, self.addr_reg_lookup(regGroup[0]))

				
	
	def write_mem_map_fields(self):
		for block in self.fieldMap.addressBlock:
			self.write_regs(block.register)


	def write_mem_map_addr(self):
		
		cmnt = "{} memory map".format(self.addrMap.name)
		self.headerGen.write_comment(cmnt, 0, small=True)
		decls = []
		
		for block in self.addrMap.addressBlock:
			for reg in sorted(block.register, key=lambda a: a.addressOffset):
				decls.append(LanDeclaration(reg.name.upper(), 
								value=reg.addressOffset*4+block.baseAddress,
								intType="enum"))
		
		self.headerGen.create_enum(self.addrMap.name.lower(), decls)
	
	
	def write_mem_map_both(self):
		self.write_mem_map_addr()
		self.write_mem_map_fields()
	
	
	def create_addrMap_package(self, name):
		
		self.headerGen.wr_nl()
		self.headerGen.write_comment("This file is autogenerated, DO NOT EDIT!",
										0, small=True)
		self.headerGen.wr_nl()
		self.headerGen.create_package(name)
		self.headerGen.wr_nl()
		
		if (self.addrMap):
			print ("Writing addresses of '%s' register map" % self.addrMap.name)
			self.write_mem_map_addr()
		
		self.headerGen.wr_nl()
		self.headerGen.wr_nl()
		
		self.headerGen.write_comment("Register descriptions:",
										0, small=False)
		
		if (self.fieldMap):
			print ("Writing bit fields of '%s' register map" % self.fieldMap.name)
			self.write_mem_map_fields()
	
		self.headerGen.commit_append_line(1)
		
	
	def write_reg(self):
		pass