<!---
 *	Filemanager CFM connector
 *
 *	filemanager.cfm
 *	use for ckeditor filemanager plug-in by Core Five - http://labs.corefive.com/Projects/FileManager/
 *
 *	@license	MIT License
 *	@author		Paul Klinkenberg, www.coldfusiondeveloper.nl/post.cfm/cfm-connector-for-ckeditor-corefive-Filemanager
 *  @date		February 28, 2010
 *  @version	1.0
 *	@copyright	Authors
--->
<cfif not isAllowed()>
	<cfset application.filemanager_obj.returnError(application.filemanager_obj.translate('AUTHORIZATION_REQUIRED')) />
</cfif>

<cfif structKeyExists(form, "mode")>
	<cfset url.mode = form.mode />
</cfif>

<cfif structKeyExists(url, "mode") and len(url.mode)>
	<cftry>
		<cfswitch expression="#url.mode#">
			<cfcase value="add">
				<cfif structKeyExists(form, "currentpath") and len(form.currentpath)>
					<cfset application.filemanager_obj.addFile(path=form.currentpath, formfieldname="newfile") />
				<cfelse>
					<cfset application.filemanager_obj.returnError("Path was not given for the 'add' function.") />
				</cfif>
			</cfcase>
			<cfcase value="addfolder">
				<cfif structKeyExists(url, "path") and structKeyExists(url, "name")>
					<cfset application.filemanager_obj.addFolder(path=path, dirname=name) />
				</cfif>	
			</cfcase>
			<cfcase value="rename">
				<cfif structKeyExists(url, "old") and structKeyExists(url, "new")>
					<cfset application.filemanager_obj.rename(oldPath=old, newName=new) />
				</cfif>
			</cfcase>
			<cfcase value="getfolder,getinfo,delete,download">
				<cfif structKeyExists(url, "path")>
					<cfinvoke component="#application.filemanager_obj#" method="#url.mode#">
						<cfinvokeargument name="path" value="#path#" />
						<cfloop list="getsize,getsizes" index="key">
							<cfif structKeyExists(url, key)>
								<cfinvokeargument name="#key#" value="#iif(listfindNoCase('1,true,yes', url[key]), 1, 0)#" />
							</cfif>
						</cfloop>
					</cfinvoke>
				<cfelse>
					<cfset application.filemanager_obj.returnError("Path was not given for the requested function.") />
				</cfif>
			</cfcase>
			<cfdefaultcase>
				<cfset application.filemanager_obj.returnError(application.filemanager_obj.translate('MODE_ERROR')) />
			</cfdefaultcase>
		</cfswitch>
		<cfcatch>
			<!---<cfmail to="paul@ongevraagdadvies.nl" from="paul@frinky.nl" subject="error filemanager" type="html">
				<cfdump var="#url#" />
				<cfdump var="#cfcatch#" />
			</cfmail>--->
			<cfrethrow />
		</cfcatch>
	</cftry>
<cfelse>
	<cfset application.filemanager_obj.returnError(application.filemanager_obj.translate('MODE_ERROR')) />
</cfif>