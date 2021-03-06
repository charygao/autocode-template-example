<%
  def varDomainName=tableNameUtil.lowerCaseFirst(tableDefine.id);
  def urlPrefix="/"+PubUtils.addStrBeforeSeparator(PubUtils.packageToPath(config.category),"/")+varDomainName;
  def columns=tableDefine.columns;
  urlPrefix=urlPrefix.replace("//","/");
  def pkColumn=tableDefine.getPkColumn();

  def containerId='update_'+varDomainName.toLowerCase();
  def requireInfo=requireUtil.getRequireInfo(tableModel,'updateList');
  if(requireInfo.hasModule()){
	 def dataMap=["requireInfo":requireInfo,"containerId":containerId];
	if(extendConf['requirejs']=='true'){
	 println snippetTemplateUtil.getTemplateByMap(dataMap,'requireJsScript');
	}else{
	  println snippetTemplateUtil.getTemplateByMap(dataMap,'elementInit');
	}
  }
%>#set(\$layout='/WEB-INF/vm/layout/adminLayout.vm')
    
<div class="modal-body"  id="${containerId}">
	<form class="form-horizontal"  id="form_update_${tableDefine.id}">
	<% columns.each{
		  def column=it;
		  if(tableModel.isNotInList('updateList',column.columnName)){
			return ;
		  }
	%>
		 <div class="control-group">
			<label class="control-label" for="${it.dataName}">${column.cnname}</label>
			<div class="controls">
			<%
		        if("Select".equalsIgnoreCase(it.jspTag)){
			        println dictUtil.getDictTemplate(column,"dict-updatePage-disp");
			}else if("radio".equalsIgnoreCase(column.jspTag)){
			        println dictUtil.getDictTemplate(column,"dict-radio-update");
			}else if("checkbox".equalsIgnoreCase(column.jspTag)){
				 println dictUtil.getDictTemplate(column,"dict-checkbox-update");
			}else if("date".equalsIgnoreCase(column.jspTag)){
				%>
				<input type="text" class="form-control j_date_picker" name="${it.dataName}" id="${it.dataName}" placeholder="请输入${column.cnname}"
				 maxlength="${it.length}" value="\$!dateFormatUtils.format(\$!${varDomainName}.${it.dataName},"yyyy-MM-dd")" />
				<%
			}else if("datetime".equalsIgnoreCase(column.jspTag)){
				%>
				<input type="text" class="form-control j_datetime_picker" name="${it.dataName}" id="${it.dataName}" placeholder="请输入${column.cnname}"
				 maxlength="${it.length}" value="\$!dateFormatUtils.format(\$!${varDomainName}.${it.dataName})" />
				<%
			 }else if("textarea".equalsIgnoreCase(column.jspTag)){
               %>
                 <textarea  name="${column.dataName}" id="${column.dataName}" placeholder="请输入${column.cnname}"  rows="5">\$!{${varDomainName}.${it.dataName}}</textarea> <%
             }else if("editor".equalsIgnoreCase(column.jspTag)){
				%>
				<textarea  name="${column.dataName}" id="${column.dataName}" class="j_editor" placeholder="请输入${column.cnname}"  style="width:95%;min-height:250px;max-width:800px;">\$!{${varDomainName}.${it.dataName}}</textarea>
				<%
			 }
			else {%>
			<input type="text"  name="${it.dataName}" id="${it.dataName}" placeholder="请输入${column.cnname}" maxlength="${it.length}" value="\$!{${varDomainName}.${it.dataName}}"<%
				if(column.getIsPK()){
					print "readonly"
				}
				print("/>");
					
			}
			%>
			</div>
		</div>
		<%
		}
		%>

	</form>
</div>
<div class="modal-footer">
	<a href="javascript:;" class="btn btn-sm btn-primary" id="btn_update_${tableDefine.id}">保存修改</a>
	<a href="javascript:;" class="btn btn-sm" onclick="backToManage();">返回</a>
</div>



<script language="javascript">

void function(j) {

	var set = {
		 <%
			def listSize=tableModel.listSize('updateList');
		 	int i=0;
			columns.each{
			  def column=it;
			  if(tableModel.isNotInList('updateList',column.columnName)){
				return ;
			  }

		    print snippetTemplateUtil.getTemplate(column,'form_rule_item');
		 	i++;
			if(i<listSize) println ',';
			
		}	
		%>
	};
	

	j('#btn_add_${tableDefine.id}').click(function(e) {
		gUtils.fSubmitForm(
			j("#form_update_${tableDefine.id}").serialize(),
			set, 
			'${urlPrefix}/doUpdate.action', 
			function() {
				gDialog.fClose();
				//queryList(1);
				backToManage();
			}
		);
	});
	
	//form.friend.init(set);
}(jQuery);


function backToManage(){
		var url='${urlPrefix}/manage.action';
			gUtils.fMakeFullLink(url);
        	window.location=url;
};
</script>