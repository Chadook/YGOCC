--Exploiter of Eternity - Thiro
function c19454004.initial_effect(c)
	--Indes. Battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(c19454004.valcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetValue(c19454004.valcon1)
	c:RegisterEffect(e2)
	--LP Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetCondition(c19454004.bacon)
	e3:SetOperation(c19454004.baop)
	c:RegisterEffect(e3)
	--Gain ATK
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(19454004,0))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c19454004.cost)
	e4:SetCondition(c19454004.con)
	e4:SetTarget(c19454004.tg)
	e4:SetOperation(c19454004.op)
	c:RegisterEffect(e4)
end
function c19454004.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c19454004.valcon1(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c19454004.bacon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	return c==e:GetHandler() and c:GetBattlePosition()==POS_FACEUP_ATTACK
end
function c19454004.baop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c19454004.lpcon)
	e1:SetOperation(c19454004.lpop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e1)
end
function c19454004.lpcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	local at=Duel.GetAttackTarget()
	local a=Duel.GetAttacker()
	return Duel.GetBattleDamage(p)>=Duel.GetLP(p) and at and at:IsControler(p)
end
function c19454004.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c19454004.damop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,p)
	Duel.SetLP(p,100,REASON_EFFECT)
end
function c19454004.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end
function c19454004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c19454004.con(e,tp,eg,ep,ev,re,r,rp)
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	return lp2-lp1>=2000
end
function c19454004.filter(c)
	return c:IsSetCard(0xe6b)
end
function c19454004.cfilter(c)
	return c:IsSetCard(0xe6b)
end
function c19454004.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19454004.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c19454004.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c19454004.filter,tp,LOCATION_MZONE,0,nil)
	if tg:GetCount()==0 then return end
	local cc=Duel.GetMatchingGroupCount(c19454004.cfilter,tp,LOCATION_MZONE,0,nil)
	local tc=tg:GetFirst()
	local atk=500*cc
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=tg:GetNext()
	end
end