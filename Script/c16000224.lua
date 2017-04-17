--Sombra, Valkyria of Magnificent Vine
function c16000224.initial_effect(c)
--pendulum summon
		aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c16000224.splimit)
	e2:SetCondition(c16000224.splimcon)
	c:RegisterEffect(e2)

		local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16000224,0))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_DICE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c16000224.target2)
	e4:SetOperation(c16000224.activate2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(16000224,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c16000224.mattg)
	e5:SetOperation(c16000224.matop)
	c:RegisterEffect(e5)
		--lv change
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(16000224,2))
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(2,16000224)
	e6:SetTarget(c16000224.target)
	e6:SetOperation(c16000224.operation)
	c:RegisterEffect(e6)

end
function c16000224.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x785c)  then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c16000224.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c16000224.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x785c)
end
function c16000224.bfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x785c) and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_EVOLUTE)
end
function c16000224.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(c16000224.bfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,c16000224.bfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c16000224.activate2(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local d=Duel.TossDice(tp,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(d*1)
			tc:RegisterEffect(e1)
		end
	end
function c16000224.tgfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x785c)
end
function c16000224.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x785c)
end
function c16000224.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c16000224.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16000224.tgfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c16000224.matfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c16000224.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c16000224.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c16000224.matfilter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
function c16000224.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x785c) and c:IsLevelAbove(1)
end
function c16000224.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c16000224.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16000224.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c16000224.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(16000224,3))
	else op=Duel.SelectOption(tp,aux.Stringid(16000224,3),aux.Stringid(16000224,4)) end
	e:SetLabel(op)
end
function c16000224.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else e1:SetValue(-1) end
		tc:RegisterEffect(e1)
	end
end