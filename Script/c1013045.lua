--Shadow Specter
function c1013045.initial_effect(c)
	--Pendulum Set
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c1013045.activate)
	c:RegisterEffect(e1)
	--Special Limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c1013045.splimcon)
	e2:SetTarget(c1013045.splimit)
	c:RegisterEffect(e2)
	--ATK Gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1013045,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,1013045)
	e3:SetCondition(c1013045.atkcon)
	e3:SetTarget(c1013045.atktg)
	e3:SetOperation(c1013045.atkop)
	c:RegisterEffect(e3)
end
function c1013045.thfilter(c)
	return (c:IsCode(1013045) or c:IsCode(40575313))
end
function c1013045.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c1013045.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c1013045.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c1013045.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsRace(RACE_ZOMBIE) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c1013045.atkcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=Duel.GetAttackTarget()
	local ac=Duel.GetAttacker()
	if bc and bc:GetAttack()>ac:GetAttack() and bc:IsControler(1-tp) 
		and ac:IsType(TYPE_NORMAL) and ac:IsLevelBelow(3) and ac:IsControler(tp) then
		e:SetLabelObject(ac)
	return true
	else return false end
end
function c1013045.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=e:GetLabelObject()
	if chkc then return chkc==tc end
	if chk==0 then return tc:IsOnField() and tc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tc)
end
function c1013045.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c1013045.cfilter,tp,LOCATION_MZONE,0,tc)
	local val=g:GetSum(Card.GetAttack)
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if c:GetFlagEffect(1013045)~=0 then return end
		local ae=Effect.CreateEffect(c)
		ae:SetType(EFFECT_TYPE_SINGLE)
		ae:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ae:SetCode(EFFECT_UPDATE_ATTACK)
		ae:SetValue(val)
		ae:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(ae)
		c:RegisterFlagEffect(1013045,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE,0,1)
	end
end
function c1013045.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsLevelBelow(3)
end