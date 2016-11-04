--Exploiter of Eternity - Atzu
function c19454001.initial_effect(c)
	--Indes. Battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(c19454001.valcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetValue(c19454001.valcon1)
	c:RegisterEffect(e2)
	--LP Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetCondition(c19454001.bacon)
	e3:SetOperation(c19454001.baop)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(19454001,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,19454001)
	e4:SetCondition(c19454001.descon)
	e4:SetTarget(c19454001.destg)
	e4:SetOperation(c19454001.desop)
	c:RegisterEffect(e4)
end
function c19454001.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c19454001.valcon1(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c19454001.bacon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	return c==e:GetHandler() and c:GetBattlePosition()==POS_FACEUP_ATTACK
end
function c19454001.baop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c19454001.lpcon)
	e1:SetOperation(c19454001.lpop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e1)
end
function c19454001.lpcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	local at=Duel.GetAttackTarget()
	local a=Duel.GetAttacker()
	return Duel.GetBattleDamage(p)>=Duel.GetLP(p) and at and at:IsControler(p)
end
function c19454001.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c19454001.damop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,p)
	Duel.SetLP(p,100,REASON_EFFECT)
end
function c19454001.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end
function c19454001.descon(e,tp,eg,ep,ev,re,r,rp)
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	return lp2-lp1>=3000
end
function c19454001.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe6b)
end
function c19454001.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c19454001.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19454001.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c19454001.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c19454001.cfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c19454001.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c19454001.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetCount()>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)
		Duel.Recover(tp,ct*300,REASON_EFFECT)
	end
end
