#!/usr/bin/env python
'''
Created on Jun 20, 2011

@author: WaTracy
'''

import wx

class CreateConfig():
    
    def OnAbout(self, e):
        dlg = wx.MessageDialog(self, "Creates a Webworks application.", 
                               'About Webworks Application Builder',wx.OK)
        dlg.ShowModal()
        dlg.Destroy()
        
    def OnExit(self, e):
        self.Close(True)

    # Create config.xml - options
    # Create index.html
    # Open chrome and browse to app
    
    # Command line options for build with phone or tablet
    # Zip files not folder and check for config.xml at root
    # Use bbwp to create .cod or .bar
    # Sign using bbwp
    
    # Installing to a device