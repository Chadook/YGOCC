--Exploiter of Eternity - Adran
function c19454006.initial_effect(c)
	--Indes. Battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(c19454006.valcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetValue(c19454006.valcon1)
	c:RegisterEffect(e2)
	--LP Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetCondition(c19454006.bacon)
	e3:SetOperation(c19454006.baop)
	c:RegisterEffect(e3)
	--Damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c19454006.damcon)
	e4:SetOperation(c19454006.damop2)
	c:RegisterEffect(e4)
end
function c19454006.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c19454006.valcon1(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c19454006.bacon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	return c==e:GetHandler() and c:GetBattlePosition()==POS_FACEUP_ATTACK
end
function c19454006.baop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c19454006.lpcon)
	e1:SetOperation(c19454006.lpop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e1)
end
function c19454006.lpcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	local at=Duel.GetAttackTarget()
	local a=Duel.GetAttacker()
	return Duel.GetBattleDamage(p)>=Duel.GetLP(p) and at and at:IsControler(p)
end
function c19454006.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c19454006.damop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,p)
	Duel.SetLP(p,100,REASON_EFFECT)
end
function c19454006.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end
function c19454006.damcon(e,tp,eg,ep,ev,re,r,rp)
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	return lp2-lp1>=3000 and Duel.GetAttackTarget()==e:GetHandler()
end
function c19454006.damop2(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	local dam=Duel.GetBattleDamage(p)
	Duel.Damage(1-tp,dam/2,REASON_BATTLE)
end
