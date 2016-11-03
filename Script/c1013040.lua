--The Snake Hair (Pendulum)
--Lesçtè Pel Kâlan
function c1013040.initial_effect(c)
	--Pendülom Sçotto
	aux.EnablePendulumAttribute(c)
	--[[	aux.AddPendulumProcedure(c)
	--Ácttanèn
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)]]--
	--Desçilare 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1013040,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,1013040)
	e2:SetCondition(c1013040.condition)
	e2:SetTarget(c1013040.target)
	e2:SetOperation(c1013040.operation)
	c:RegisterEffect(e2)
	--Desçukttdientt
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c1013040.descon)
	e3:SetOperation(c1013040.desop)
	c:RegisterEffect(e3)
end
function c1013040.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(1013040)~=1
end
function c1013040.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c1013040.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1013040.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1013040.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1013040.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c1013040.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c1013040.rcon)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		tc:RegisterEffect(e2,true)
	end
	c:RegisterFlagEffect(1013040,RESET_EVENT+0x1fe0000,0,1)
end
function c1013040.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function c1013040.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_DESTROY_CONFIRMED) then return false end
	local tc=c:GetFirstCardTarget()
	return tc and eg:IsContains(tc) and tc:IsReason(REASON_DESTROY)
end
function c1013040.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
