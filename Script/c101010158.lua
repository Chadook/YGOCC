--created & coded by Lyris
--Ｓ・Ｖｉｎｅの少女－ジャッキー
function c101010158.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--destroyed
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLED)
	e3:SetCondition(c101010158.condition)
	e3:SetTarget(c101010158.target)
	e3:SetOperation(c101010158.operation)
	c:RegisterEffect(e3)
end
function c101010158.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()==e:GetHandler()
end
function c101010158.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,Duel.GetAttacker(),1,0,0)
end
function c101010158.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	if not a:IsRelateToBattle() then return end
	if Duel.Remove(a,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		c:RegisterFlagEffect(101010158,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local g=Group.FromCards(a)
		a:RegisterFlagEffect(101010158,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		g:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(g)
		e1:SetOperation(c101010158.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101010158.retfilter(c)
	return c:GetFlagEffect(101010158)~=0
end
function c101010158.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c101010158.retfilter,nil)
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		if Duel.ReturnToField(tc) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetOwner())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
		tc=sg:GetNext()
	end
end
