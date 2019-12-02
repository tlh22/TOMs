#-----------------------------------------------------------
# Licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#---------------------------------------------------------------------
# Tim Hancock 2017

from enum import Enum

class ProposalStatus(object):
    IN_PREPARATION = 1
    ACCEPTED = 2
    REJECTED = 3

class RestrictionAction(object):
    OPEN = 1
    CLOSE = 2

class RestrictionLayers(object):
    BAYS = 2
    LINES = 3
    RESTRICTION_POLYGONS = 4
    SIGNS = 5
    CPZS = 6
    PTAS = 7

def singleton(myClass):
    # From https://www.youtube.com/watch?v=6IV_FYx6MQA
    instances = {}
    def getInstance(*args, **kwargs):
        if myClass not in instances:
            instances[myClass] = myClass(*args, **kwargs)
            return instances[myClass]
    return getInstance
