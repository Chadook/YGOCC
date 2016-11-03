--Mech Mole Pendulum Zombie
--Mek Zöe Pedülom Zombi
function c1013044.initial_effect(c)
	--Péndülóm Sçótto
	aux.EnablePendulumAttribute(c)
	--[[	aux.AddPendulumProcedure(c)
	--Ácttanèn
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)]]--
	--Pendülom Köka
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1013044,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,1013044)
	e2:SetTarget(c1013044.rettg)
	e2:SetOperation(c1013044.retop)
	c:RegisterEffect(e2)
	--Desçukkidientt
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1013044,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,1013044)
	e3:SetTarget(c1013044.thtg)
	e3:SetOperation(c1013044.thop)
	c:RegisterEffect(e3)
end
function c1013044.thfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c1013044.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(c1013044.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1013044.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1013044.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1013044.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=Duel.GetAttackTarget()
	local ac=Duel.GetAttacker()
	if chk==0 then return (e:GetHandler()==bc or bc~=nil) and (bc:IsControler(tp) or ac:IsControler(tp)) end
	local g=Group.FromCards(Duel.GetAttacker(),Duel.GetAttackTarget())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c1013044.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local bc=Duel.GetAttackTarget()
	local ac=Duel.GetAttacker()
	--Meúx karttehn 
	if ac:IsControler(tp) then
		if ac:IsRelateToBattle() then g:AddCard(ac) end
		if bc and bc:IsRelateToBattle() then g:AddCard(bc) end
	end
	--Seúx karttehn
	if bc:IsControler(tp) then
		if bc and bc:IsRelateToBattle() then g:AddCard(bc) end
		if ac:IsRelateToBattle() then g:AddCard(ac) end
	end
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
