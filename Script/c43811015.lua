--Young Prince of the Phantasm
function c43811015.initial_effect(c)
	--Synchro Summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x90e),aux.NonTuner(Card.IsSetCard,0x90e),1)
	c:EnableReviveLimit()
	--Damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c43811015.lpcon)
	e1:SetOperation(c43811015.lpop)
	c:RegisterEffect(e1)
	--Gain ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(0)
	e2:SetCondition(c43811015.regcon)
	e2:SetOperation(c43811015.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabelObject(e2)
	e3:SetCondition(c43811015.atkcon)
	e3:SetOperation(c43811015.atkop)
	c:RegisterEffect(e3)
end
function c43811015.cfilter(c,tp)
	return c:IsSetCard(0x90e) and c:GetPreviousControler()==tp 
end
function c43811015.lpcon(e,tp,eg,ev,ep,re,r,rp)
	return eg:IsExists(c43811015.cfilter,1,nil,tp)
end
function c43811015.lpop(e,tp,eg,ev,ep,re,r,rp)
	local g=eg:Filter(c43811015.cfilter,nil,tp)
	Duel.Damage(1-tp,g:GetCount()*300,REASON_EFFECT)
end
function c43811015.regcon(e,tp,eg,ev,ep,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c43811015.regop(e,tp,eg,ev,ep,re,r,rp)
	local val=e:GetLabel()
	if eg:IsExists(Card.IsSetCard,1,nil,0x90e) then
		local ct=eg:FilterCount(Card.IsSetCard,nil,0x90e)
		val=val+ct
		e:SetLabel(val)
	end
end
function c43811015.atkcon(e,tp,eg,ev,ep,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetLabelObject():GetLabel()~=0
end
function c43811015.atkop(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local val=e:GetLabelObject():GetLabel()
	if c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500*val)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e1)
	end
	e:GetLabelObject():SetLabel(0)
end
